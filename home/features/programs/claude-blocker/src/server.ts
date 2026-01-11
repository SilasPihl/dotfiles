import { createServer, IncomingMessage, ServerResponse } from "http";
import { WebSocketServer, WebSocket } from "ws";
import { state } from "./state.js";
import { HookPayload, DEFAULT_PORT } from "./types.js";

function parseBody(req: IncomingMessage): Promise<string> {
  return new Promise((resolve, reject) => {
    let body = "";
    req.on("data", (chunk: Buffer) => (body += chunk.toString()));
    req.on("end", () => resolve(body));
    req.on("error", reject);
  });
}

function sendJson(res: ServerResponse, data: unknown, status = 200): void {
  res.writeHead(status, { "Content-Type": "application/json" });
  res.end(JSON.stringify(data));
}

export function startServer(port: number = DEFAULT_PORT): void {
  const server = createServer(async (req, res) => {
    // CORS headers for local development
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type");

    if (req.method === "OPTIONS") {
      res.writeHead(204);
      res.end();
      return;
    }

    const url = new URL(req.url || "/", `http://localhost:${port}`);

    // Health check / status endpoint
    if (req.method === "GET" && url.pathname === "/status") {
      sendJson(res, state.getStatus());
      return;
    }

    // Hook endpoint - receives notifications from Claude Code
    if (req.method === "POST" && url.pathname === "/hook") {
      try {
        const body = await parseBody(req);
        const payload = JSON.parse(body) as HookPayload;

        if (!payload.session_id || !payload.hook_event_name) {
          sendJson(res, { error: "Invalid payload" }, 400);
          return;
        }

        console.log(
          `[${new Date().toISOString()}] ${payload.hook_event_name}${payload.tool_name ? ` (${payload.tool_name})` : ""} - session: ${payload.session_id.slice(0, 8)}...`
        );

        state.handleHook(payload);
        sendJson(res, { ok: true });
      } catch {
        sendJson(res, { error: "Invalid JSON" }, 400);
      }
      return;
    }

    // Root endpoint - show basic info
    if (req.method === "GET" && url.pathname === "/") {
      sendJson(res, {
        name: "claude-blocker",
        endpoints: {
          status: "GET /status",
          hook: "POST /hook",
          websocket: "WS /ws",
        },
      });
      return;
    }

    sendJson(res, { error: "Not found" }, 404);
  });

  // WebSocket server for real-time updates
  const wss = new WebSocketServer({ server, path: "/ws" });

  wss.on("connection", (ws: WebSocket) => {
    console.log("[ws] Client connected");

    const unsubscribe = state.subscribe((message) => {
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(JSON.stringify(message));
      }
    });

    ws.on("message", (data: Buffer) => {
      try {
        const message = JSON.parse(data.toString());
        if (message.type === "ping") {
          ws.send(JSON.stringify({ type: "pong" }));
        }
      } catch {
        // Ignore invalid messages
      }
    });

    ws.on("close", () => {
      console.log("[ws] Client disconnected");
      unsubscribe();
    });
    ws.on("error", () => unsubscribe());
  });

  server.listen(port, () => {
    console.log(`Claude Blocker running on http://localhost:${port}`);
    console.log(`WebSocket on ws://localhost:${port}/ws`);
    console.log(`\nEndpoints:`);
    console.log(`  GET  /status - Get session status`);
    console.log(`  POST /hook   - Receive hook events`);
    console.log(`  WS   /ws     - Real-time updates`);
  });

  process.once("SIGINT", () => {
    console.log("\nShutting down...");
    state.destroy();
    wss.close();
    server.close();
    process.exit(0);
  });

  process.once("SIGTERM", () => {
    state.destroy();
    wss.close();
    server.close();
    process.exit(0);
  });
}
