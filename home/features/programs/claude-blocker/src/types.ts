export interface HookPayload {
  session_id: string;
  hook_event_name:
    | "UserPromptSubmit"
    | "PreToolUse"
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
  cwd?: string;
}

export interface StateMessage {
  type: "state";
  blocked: boolean;
  sessions: number;
  working: number;
  waitingForInput: number;
}

export interface StatusResponse {
  blocked: boolean;
  sessions: Session[];
}

export const USER_INPUT_TOOLS = ["AskUserQuestion", "ask_user", "ask_human"];
export const DEFAULT_PORT = 8765;
export const SESSION_TIMEOUT_MS = 5 * 60 * 1000; // 5 minutes
