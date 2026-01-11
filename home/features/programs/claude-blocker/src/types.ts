export interface HookPayload {
  session_id: string;
  hook_event_name:
    | "UserPromptSubmit"
    | "PreToolUse"
    | "PostToolUse"
    | "Stop"
    | "SessionStart"
    | "SessionEnd";
  tool_name?: string;
  tool_input?: Record<string, unknown>;
  cwd?: string;
  transcript_path?: string;
}

export interface Session {
  id: string;
  status: "idle" | "working" | "waiting_for_input";
  lastActivity: Date;
  waitingForInputSince?: Date;
  pendingToolSince?: Date;
  cwd?: string;
}

export interface SessionInfo {
  id: string;
  status: "idle" | "working" | "waiting_for_input";
  cwd?: string;
}

export interface StateMessage {
  type: "state";
  blocked: boolean;
  sessionCount: number;
  working: number;
  waitingForInput: number;
  sessions: SessionInfo[];
}

export interface StatusResponse {
  blocked: boolean;
  sessions: Session[];
}

export const USER_INPUT_TOOLS = ["AskUserQuestion", "ask_user", "ask_human"];
export const DEFAULT_PORT = 8765;
export const SESSION_TIMEOUT_MS = 5 * 60 * 1000; // 5 minutes
export const TOOL_APPROVAL_WAIT_MS = 2000; // 2 seconds before assuming tool needs approval
