// Dev Hub - Popup Script

// Status priority for sorting (lower = higher priority)
const STATUS_PRIORITY = {
  waiting_for_input: 0,
  working: 1,
  idle: 2,
};

const STATUS_LABELS = {
  waiting_for_input: "waiting",
  working: "working",
  idle: "idle",
};

function sortSessions(sessions) {
  return [...sessions].sort((a, b) => {
    return STATUS_PRIORITY[a.status] - STATUS_PRIORITY[b.status];
  });
}

function getDisplayPath(cwd) {
  if (!cwd) return "unknown";
  // Show just the last part of the path for brevity
  const parts = cwd.split("/");
  return parts[parts.length - 1] || cwd;
}

function renderSessionList(sessions) {
  if (!sessions || sessions.length === 0) {
    return '<div class="no-sessions">No active sessions</div>';
  }

  const sorted = sortSessions(sessions);
  return `
    <div class="session-list">
      ${sorted
        .map(
          (s) => `
        <div class="session-item" title="${s.cwd || "unknown"}">
          <div class="session-status ${s.status}"></div>
          <div class="session-cwd">${getDisplayPath(s.cwd)}</div>
          <div class="session-status-label">${STATUS_LABELS[s.status]}</div>
        </div>
      `
        )
        .join("")}
    </div>
  `;
}

function render() {
  chrome.runtime.sendMessage({ type: "getState" }, (response) => {
    const { state, connected } = response || { state: null, connected: false };
    const statusDot = document.getElementById("statusDot");
    const content = document.getElementById("content");

    if (!connected) {
      statusDot.className = "status-dot offline";
      content.innerHTML = `
        <div class="section">
          <div class="section-header">Sessions</div>
          <div class="offline-msg">
            Server offline
            <code>claude-blocker</code>
          </div>
        </div>
      `;
      return;
    }

    // Determine overall status
    let status = "idle";
    if (state.waitingForInput > 0) {
      status = "waiting";
    } else if (state.working > 0) {
      status = "working";
    }

    statusDot.className = `status-dot ${status}`;

    const sessionCount = state.sessionCount || 0;
    const idle = sessionCount - state.working - state.waitingForInput;

    content.innerHTML = `
      <div class="section">
        <div class="section-header">Sessions</div>
        <div class="stats">
          <div class="stat">
            <div class="stat-label">Sessions</div>
            <div class="stat-value">${sessionCount}</div>
          </div>
          <div class="stat">
            <div class="stat-label">Working</div>
            <div class="stat-value working">${state.working}</div>
          </div>
          <div class="stat">
            <div class="stat-label">Waiting</div>
            <div class="stat-value waiting">${state.waitingForInput}</div>
          </div>
          <div class="stat">
            <div class="stat-label">Idle</div>
            <div class="stat-value idle">${idle}</div>
          </div>
        </div>
        ${renderSessionList(state.sessions)}
      </div>
    `;
  });
}

// Refresh button handler - just re-render UI with current state
document.getElementById("refreshBtn").addEventListener("click", (e) => {
  const btn = e.target;
  btn.classList.add("spinning");
  setTimeout(() => {
    btn.classList.remove("spinning");
    render();
  }, 300);
});

// Auto-refresh toggle
let autoRefreshInterval = null;
const toggle = document.getElementById("autoRefreshToggle");

function setAutoRefresh(enabled) {
  if (enabled) {
    toggle.classList.add("active");
    if (!autoRefreshInterval) {
      autoRefreshInterval = setInterval(render, 1000);
    }
  } else {
    toggle.classList.remove("active");
    if (autoRefreshInterval) {
      clearInterval(autoRefreshInterval);
      autoRefreshInterval = null;
    }
  }
  // Persist preference (if storage available)
  if (chrome?.storage?.local) {
    chrome.storage.local.set({ autoRefresh: enabled });
  }
}

toggle.addEventListener("click", () => {
  const isActive = toggle.classList.contains("active");
  setAutoRefresh(!isActive);
});

// Load saved preference and initial render
if (chrome?.storage?.local) {
  chrome.storage.local.get(["autoRefresh"], (result) => {
    if (result.autoRefresh) {
      setAutoRefresh(true);
    }
    render();
  });
} else {
  render();
}
