// Dev Hub - Popup Script

const SHORTCUTS = [
  {
    name: "Git",
    items: [
      ["gl", "git pull --rebase"],
      ["ga", "git add"],
      ["gaa", "git add ."],
      ["gp", "git push"],
      ["gpf", "push --force-with-lease"],
      ["gst", "git status"],
      ["gco", "git checkout"],
      ["gc", "commit (AI message)"],
      ["gd", "git diff"],
      ["gr", "git restore"],
      ["grs", "git restore --staged"],
      ["grrevert", "restore all from HEAD"],
      ["lg", "lazygit (tmux zoom)"],
      ["gitc", "quick commit [msg]"],
      ["gci", "interactive checkout"],
      ["grsoft", "soft reset [n]"],
      ["grhard", "hard reset [n]"],
      ["grremote", "reset to remote [-f]"],
    ],
  },
  {
    name: "Git Worktree",
    items: [
      ["gw", "git worktree"],
      ["gwl", "git worktree list"],
      ["gwadd", "new worktree <name> [branch]"],
      ["gwfork", "fork worktree + tmux win"],
      ["gwdiff", "diff vs parent (split)"],
      ["gwback", "apply changes to parent"],
      ["gwrm", "remove worktree (fzf)"],
      ["gwswitch", "switch worktree (fzf)"],
      ["gwcd", "cd to worktree (fzf)"],
    ],
  },
  {
    name: "Tmux",
    items: [
      ["tl", "list sessions"],
      ["ta", "attach session -t"],
      ["tk", "kill session -t"],
      ["td", "detach"],
      ["tn", "new session -s"],
    ],
  },
  {
    name: "Docker / Tilt",
    items: [
      ["up", "compose up"],
      ["down", "compose down (selective)"],
      ["downf", "compose down (full)"],
      ["tup", "tilt up"],
      ["tup0-3", "tilt up (config 0-3)"],
      ["ld", "lazydocker"],
    ],
  },
  {
    name: "Navigation",
    items: [
      ["cd", "z (zoxide)"],
      ["cdd", "builtin cd"],
      ["cda", "add subdirs to zoxide"],
      ["cdf", "cd frontend + rebuild"],
      ["y", "yazi (dir tracking)"],
      ["ls", "eza"],
      ["lt", "eza tree (-lTag)"],
      ["lt1-3", "eza tree (level 1-3)"],
    ],
  },
  {
    name: "Tools",
    items: [
      ["v", "nvim"],
      ["t", "task"],
      ["c", "cursor (+ hammerspoon)"],
      ["cc", "claude"],
      ["ccd", "claude (skip perms)"],
      ["cl", "clear"],
      ["cat", "bat"],
      ["grep", "rg (ripgrep)"],
      ["dev", "nix develop"],
    ],
  },
  {
    name: "System",
    items: [
      ["sz", "source ~/.zshrc"],
      ["tload", "home-manager switch + sz"],
      ["cleanup", "nix garbage collect"],
    ],
  },
];

function renderShortcuts() {
  return `
    <hr class="shortcuts-divider">
    <div class="section">
      <div class="section-header">Shortcuts</div>
      ${SHORTCUTS.map(
        (cat, i) => `
        <div class="shortcut-category">
          <div class="shortcut-category-header" data-cat="${i}">
            <span class="shortcut-arrow" id="arrow-${i}">&#9654;</span>
            ${cat.name}
          </div>
          <div class="shortcut-items" id="cat-${i}">
            ${cat.items
              .map(
                ([key, desc]) => `
              <div class="shortcut-item">
                <span class="shortcut-key">${key}</span>
                <span class="shortcut-desc">${desc}</span>
              </div>
            `
              )
              .join("")}
          </div>
        </div>
      `
      ).join("")}
    </div>
  `;
}

function initShortcutToggles() {
  // Load saved state
  const saved = JSON.parse(localStorage.getItem("shortcutCats") || "{}");
  SHORTCUTS.forEach((_, i) => {
    if (saved[i]) {
      document.getElementById(`cat-${i}`)?.classList.add("open");
      document.getElementById(`arrow-${i}`)?.classList.add("open");
    }
  });

  document.querySelectorAll(".shortcut-category-header").forEach((header) => {
    header.addEventListener("click", () => {
      const idx = header.dataset.cat;
      const items = document.getElementById(`cat-${idx}`);
      const arrow = document.getElementById(`arrow-${idx}`);
      items?.classList.toggle("open");
      arrow?.classList.toggle("open");
      // Persist
      const state = JSON.parse(localStorage.getItem("shortcutCats") || "{}");
      state[idx] = items?.classList.contains("open");
      localStorage.setItem("shortcutCats", JSON.stringify(state));
    });
  });
}

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
        ${renderShortcuts()}
      `;
      initShortcutToggles();
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
      ${renderShortcuts()}
    `;
    initShortcutToggles();
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
