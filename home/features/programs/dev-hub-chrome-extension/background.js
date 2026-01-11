// Dev Hub - Background Service Worker
// Notification hub for development: Claude status, GitHub, and more
const WS_URL = "ws://localhost:8765/ws";
const RECONNECT_DELAY = 5000;

let ws = null;
let state = { blocked: true, sessions: 0, working: 0, waitingForInput: 0 };
let lastWaitingNotification = 0;

// Keep service worker alive - MV3 suspends workers when idle
chrome.alarms.create("keepalive", { periodInMinutes: 0.4 });
chrome.alarms.onAlarm.addListener((alarm) => {
  if (alarm.name === "keepalive") {
    if (!ws || ws.readyState !== WebSocket.OPEN) {
      connect();
    }
  }
});

// Badge colors
const COLORS = {
  idle: "#22c55e",      // green - free to use
  working: "#ef4444",   // red - Claude is working
  waiting: "#eab308",   // yellow - needs input
  offline: "#6b7280",   // gray - server offline
};

function updateBadge() {
  let color, text;

  if (!ws || ws.readyState !== WebSocket.OPEN) {
    color = COLORS.offline;
    text = "?";
  } else if (state.waitingForInput > 0) {
    color = COLORS.waiting;
    text = state.waitingForInput.toString();
  } else if (state.working > 0) {
    color = COLORS.working;
    text = state.working.toString();
  } else {
    color = COLORS.idle;
    text = state.sessions > 0 ? state.sessions.toString() : "";
  }

  chrome.action.setBadgeBackgroundColor({ color });
  chrome.action.setBadgeText({ text });
}

function showNotification(title, message) {
  chrome.notifications.create({
    type: "basic",
    iconUrl: "icons/icon-waiting-128.png",
    title,
    message,
  });
}

function handleMessage(data) {
  const msg = JSON.parse(data);
  if (msg.type === "state") {
    const prevWaiting = state.waitingForInput;
    state = msg;
    updateBadge();

    // Notify when Claude starts waiting for input
    const now = Date.now();
    if (msg.waitingForInput > prevWaiting && now - lastWaitingNotification > 30000) {
      lastWaitingNotification = now;
      showNotification(
        "Claude needs input",
        `${msg.waitingForInput} session(s) waiting for your response`
      );
    }
  }
}

function connect() {
  if (ws && ws.readyState === WebSocket.OPEN) return;

  try {
    ws = new WebSocket(WS_URL);

    ws.onopen = () => {
      console.log("[Claude Status] Connected to server");
      updateBadge();
    };

    ws.onmessage = (event) => {
      handleMessage(event.data);
    };

    ws.onclose = () => {
      console.log("[Claude Status] Disconnected, reconnecting...");
      ws = null;
      updateBadge();
      setTimeout(connect, RECONNECT_DELAY);
    };

    ws.onerror = (error) => {
      console.error("[Claude Status] WebSocket error:", error);
      ws.close();
    };
  } catch (error) {
    console.error("[Claude Status] Connection failed:", error);
    setTimeout(connect, RECONNECT_DELAY);
  }
}

// Handle messages from popup
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.type === "getState") {
    sendResponse({
      state,
      connected: ws && ws.readyState === WebSocket.OPEN,
    });
  } else if (request.type === "reconnect") {
    // Force reconnect
    if (ws) {
      ws.close();
    }
    ws = null;
    connect();
    sendResponse({ ok: true });
  }
  return true;
});

// Start connection
connect();
updateBadge();
