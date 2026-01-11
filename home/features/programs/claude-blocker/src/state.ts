import {
  HookPayload,
  Session,
  StateMessage,
  StatusResponse,
  USER_INPUT_TOOLS,
  SESSION_TIMEOUT_MS,
} from "./types.js";

type Listener = (message: StateMessage) => void;

class SessionState {
  private sessions: Map<string, Session> = new Map();
  private listeners: Set<Listener> = new Set();
  private cleanupInterval: NodeJS.Timeout | null = null;

  constructor() {
    this.cleanupInterval = setInterval(
      () => this.cleanupStaleSessions(),
      30_000
    );
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
  }

  private getStateMessage(): StateMessage {
    const sessions = Array.from(this.sessions.values());
    const working = sessions.filter((s) => s.status === "working").length;
    const waitingForInput = sessions.filter(
      (s) => s.status === "waiting_for_input"
    ).length;
    return {
      type: "state",
      blocked: working === 0,
      sessions: sessions.length,
      working,
      waitingForInput,
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
          toolSession.status = "waiting_for_input";
          toolSession.waitingForInputSince = new Date();
        } else {
          toolSession.status = "working";
        }
        toolSession.lastActivity = new Date();
        break;
      }

      case "Stop": {
        this.ensureSession(session_id, payload.cwd);
        const idleSession = this.sessions.get(session_id)!;
        idleSession.status = "idle";
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

  getStatus(): StatusResponse {
    const sessions = Array.from(this.sessions.values());
    return {
      blocked: sessions.filter((s) => s.status === "working").length === 0,
      sessions,
    };
  }

  destroy(): void {
    if (this.cleanupInterval) clearInterval(this.cleanupInterval);
    this.sessions.clear();
    this.listeners.clear();
  }
}

export const state = new SessionState();
