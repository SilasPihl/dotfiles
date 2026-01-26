import { spawn, ChildProcess } from "child_process";
import {
  HookPayload,
  Session,
  SessionInfo,
  StateMessage,
  StatusResponse,
  USER_INPUT_TOOLS,
  SESSION_TIMEOUT_MS,
  TOOL_APPROVAL_WAIT_MS,
} from "./types.js";

type Listener = (message: StateMessage) => void;

class SessionState {
  private sessions: Map<string, Session> = new Map();
  private listeners: Set<Listener> = new Set();
  private cleanupInterval: NodeJS.Timeout | null = null;
  private pendingToolInterval: NodeJS.Timeout | null = null;
  private caffeinateProcess: ChildProcess | null = null;

  constructor() {
    this.cleanupInterval = setInterval(
      () => this.cleanupStaleSessions(),
      30_000
    );
    // Check for tools waiting on approval every 500ms
    this.pendingToolInterval = setInterval(
      () => this.checkPendingTools(),
      500
    );
  }

  private updateCaffeinate(): void {
    // Keep caffeinate on for any active session (working or waiting for input)
    // Only allow sleep when all sessions are idle or closed
    const activeCount = Array.from(this.sessions.values()).filter(
      (s) => s.status !== "idle"
    ).length;

    if (activeCount > 0 && !this.caffeinateProcess) {
      // Start caffeinate to prevent sleep
      this.caffeinateProcess = spawn("caffeinate", ["-d", "-i"], {
        stdio: "ignore",
        detached: false,
      });
      this.caffeinateProcess.on("error", (err) => {
        console.error("[caffeinate] Failed to start:", err.message);
        this.caffeinateProcess = null;
      });
      this.caffeinateProcess.on("exit", () => {
        this.caffeinateProcess = null;
      });
      console.log("[caffeinate] Started - preventing sleep while session active");
    } else if (activeCount === 0 && this.caffeinateProcess) {
      // Stop caffeinate
      this.caffeinateProcess.kill();
      this.caffeinateProcess = null;
      console.log("[caffeinate] Stopped - all sessions idle, sleep allowed");
    }
  }

  subscribe(callback: Listener): () => void {
    this.listeners.add(callback);
    callback(this.getStateMessage());
    return () => this.listeners.delete(callback);
  }

  private broadcast(): void {
    const message = this.getStateMessage();
    for (const listener of this.listeners) {
      listener(message);
    }
    this.updateCaffeinate();
  }

  private getStateMessage(): StateMessage {
    const sessions = Array.from(this.sessions.values());
    const working = sessions.filter((s) => s.status === "working").length;
    const waitingForInput = sessions.filter(
      (s) => s.status === "waiting_for_input"
    ).length;

    // Convert to SessionInfo for the message
    const sessionInfos: SessionInfo[] = sessions.map((s) => ({
      id: s.id,
      status: s.status,
      cwd: s.cwd,
    }));

    return {
      type: "state",
      blocked: working === 0,
      sessionCount: sessions.length,
      working,
      waitingForInput,
      sessions: sessionInfos,
    };
  }

  handleHook(payload: HookPayload): void {
    const { session_id, hook_event_name } = payload;

    switch (hook_event_name) {
      case "SessionStart":
        this.sessions.set(session_id, {
          id: session_id,
          status: "idle",
          lastActivity: new Date(),
          cwd: payload.cwd,
        });
        break;

      case "SessionEnd":
        this.sessions.delete(session_id);
        break;

      case "UserPromptSubmit": {
        this.ensureSession(session_id, payload.cwd);
        const promptSession = this.sessions.get(session_id)!;
        promptSession.status = "working";
        promptSession.waitingForInputSince = undefined;
        promptSession.lastActivity = new Date();
        break;
      }

      case "PreToolUse": {
        this.ensureSession(session_id, payload.cwd);
        const toolSession = this.sessions.get(session_id)!;
        if (payload.tool_name && USER_INPUT_TOOLS.includes(payload.tool_name)) {
          // Known user-input tools → immediately mark as waiting
          toolSession.status = "waiting_for_input";
          toolSession.waitingForInputSince = new Date();
          toolSession.pendingToolSince = undefined;
        } else {
          // Other tools → mark pending, will switch to waiting if approval takes too long
          toolSession.status = "working";
          toolSession.pendingToolSince = new Date();
        }
        toolSession.lastActivity = new Date();
        break;
      }

      case "PostToolUse": {
        this.ensureSession(session_id, payload.cwd);
        const postToolSession = this.sessions.get(session_id)!;
        // Tool completed, clear pending state
        postToolSession.pendingToolSince = undefined;
        postToolSession.status = "working";
        postToolSession.lastActivity = new Date();
        break;
      }

      case "Stop": {
        this.ensureSession(session_id, payload.cwd);
        const idleSession = this.sessions.get(session_id)!;
        idleSession.status = "idle";
        idleSession.pendingToolSince = undefined;
        idleSession.waitingForInputSince = undefined;
        idleSession.lastActivity = new Date();
        break;
      }
    }

    this.broadcast();
  }

  private ensureSession(sessionId: string, cwd?: string): void {
    if (!this.sessions.has(sessionId)) {
      this.sessions.set(sessionId, {
        id: sessionId,
        status: "idle",
        lastActivity: new Date(),
        cwd,
      });
    }
  }

  private cleanupStaleSessions(): void {
    const now = Date.now();
    let removed = false;
    for (const [id, session] of this.sessions) {
      if (now - session.lastActivity.getTime() > SESSION_TIMEOUT_MS) {
        this.sessions.delete(id);
        removed = true;
      }
    }
    if (removed) {
      this.broadcast();
    }
  }

  private checkPendingTools(): void {
    const now = Date.now();
    let changed = false;
    for (const session of this.sessions.values()) {
      if (
        session.pendingToolSince &&
        session.status === "working" &&
        now - session.pendingToolSince.getTime() > TOOL_APPROVAL_WAIT_MS
      ) {
        // Tool has been pending too long, likely waiting for approval
        session.status = "waiting_for_input";
        session.waitingForInputSince = session.pendingToolSince;
        changed = true;
      }
    }
    if (changed) {
      this.broadcast();
    }
  }

  getStatus(): StatusResponse {
    const sessions = Array.from(this.sessions.values());
    return {
      blocked: sessions.filter((s) => s.status === "working").length === 0,
      sessions,
    };
  }

  destroy(): void {
    if (this.cleanupInterval) clearInterval(this.cleanupInterval);
    if (this.pendingToolInterval) clearInterval(this.pendingToolInterval);
    if (this.caffeinateProcess) {
      this.caffeinateProcess.kill();
      this.caffeinateProcess = null;
    }
    this.sessions.clear();
    this.listeners.clear();
  }
}

export const state = new SessionState();
