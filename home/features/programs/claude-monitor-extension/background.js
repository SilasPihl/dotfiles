// Claude Monitor - Background Service Worker
// Monitor Claude Code sessions and prevent sleep while working
const WS_URL = "ws://localhost:8765/ws";
const RECONNECT_DELAY = 5000;

let ws = null;
let state = { blocked: true, sessionCount: 0, working: 0, waitingForInput: 0, sessions: [] };
let lastWaitingNotification = 0;

// Keep service worker alive - MV3 suspends workers when idle
chrome.alarms.create("keepalive", { periodInMinutes: 0.4 });
chrome.alarms.onAlarm.addListener((alarm) => {
  if (alarm.name === "keepalive") {
    // Only reconnect if truly disconnected (not if still connecting)
    if (!ws || (ws.readyState !== WebSocket.OPEN && ws.readyState !== WebSocket.CONNECTING)) {
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
  } else if (state.waitingForInput > 0 && state.working > 0) {
    // Both waiting and working: "⏳2·1" (waiting·working)
    color = COLORS.waiting;
    text = `⏳${state.waitingForInput}·${state.working}`;
  } else if (state.waitingForInput > 0) {
    color = COLORS.waiting;
    text = `⏳${state.waitingForInput}`;
  } else if (state.working > 0) {
    color = COLORS.working;
    text = `⚙${state.working}`;
  } else if (state.sessionCount > 0) {
    color = COLORS.idle;
    text = `✓${state.sessionCount}`;
  } else {
    color = COLORS.idle;
    text = "";
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

function broadcastToTabs() {
  const connected = ws && ws.readyState === WebSocket.OPEN;
  chrome.tabs.query({}, (tabs) => {
    for (const tab of tabs) {
      chrome.tabs.sendMessage(tab.id, { type: "STATE_UPDATE", state, connected }).catch(() => {});
    }
  });
}

function handleMessage(data) {
  const msg = JSON.parse(data);
  if (msg.type === "state") {
    const prevWaiting = state.waitingForInput;
    state = msg;
    updateBadge();
    broadcastToTabs();

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
  // Check for both OPEN and CONNECTING to avoid duplicate connections
  if (ws && (ws.readyState === WebSocket.OPEN || ws.readyState === WebSocket.CONNECTING)) return;

  try {
    ws = new WebSocket(WS_URL);

    ws.onopen = () => {
      console.log("[Claude Monitor] Connected to server");
      updateBadge();
      broadcastToTabs();
    };

    ws.onmessage = (event) => {
      handleMessage(event.data);
    };

    ws.onclose = () => {
      console.log("[Claude Monitor] Disconnected, reconnecting...");
      ws = null;
      updateBadge();
      broadcastToTabs();
      setTimeout(connect, RECONNECT_DELAY);
    };

    ws.onerror = (error) => {
      console.error("[Claude Monitor] WebSocket error:", error);
      ws.close();
    };
  } catch (error) {
    console.error("[Claude Monitor] Connection failed:", error);
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
    // Force reconnect - remove handlers before closing to avoid race condition
    if (ws) {
      ws.onclose = null;
      ws.onerror = null;
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
