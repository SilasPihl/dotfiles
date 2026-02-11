// Claude Monitor - Content Script (Toast Nudge)
// Shows a non-blocking toast when no Claude sessions are running.

(() => {
  const DISMISS_DURATION = 5 * 60 * 1000; // 5 minutes
  const HOST_ID = "__claude-monitor-toast";

  let dismissedUntil = 0;
  let currentState = null;
  let currentConnected = null;
  let hostEl = null;
  let shadowRoot = null;
  let observer = null;

  // ── Styles (Catppuccin Mocha) ──────────────────────────────────
  const CSS = `
    :host {
      all: initial;
      position: fixed;
      bottom: 20px;
      right: 20px;
      z-index: 2147483647;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      pointer-events: none;
    }
    .toast {
      pointer-events: auto;
      background: #1e1e2e;
      color: #cdd6f4;
      border: 1px solid #45475a;
      border-radius: 10px;
      padding: 12px 16px;
      display: flex;
      align-items: center;
      gap: 10px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
      opacity: 0;
      transform: translateY(12px);
      transition: opacity 0.25s ease, transform 0.25s ease;
      max-width: 320px;
      font-size: 13px;
      line-height: 1.4;
    }
    .toast.visible {
      opacity: 1;
      transform: translateY(0);
    }
    .icon {
      font-size: 18px;
      flex-shrink: 0;
    }
    .msg {
      flex: 1;
    }
    .close {
      background: none;
      border: none;
      color: #6c7086;
      cursor: pointer;
      font-size: 16px;
      padding: 0 0 0 4px;
      line-height: 1;
      flex-shrink: 0;
    }
    .close:hover {
      color: #cdd6f4;
    }
    .offline {
      color: #f38ba8;
    }
  `;

  // ── DOM setup ──────────────────────────────────────────────────
  function createHost() {
    if (document.getElementById(HOST_ID)) return;
    hostEl = document.createElement("div");
    hostEl.id = HOST_ID;
    shadowRoot = hostEl.attachShadow({ mode: "closed" });

    const style = document.createElement("style");
    style.textContent = CSS;
    shadowRoot.appendChild(style);

    const toast = document.createElement("div");
    toast.className = "toast";
    toast.innerHTML = `
      <span class="icon"></span>
      <span class="msg"></span>
      <button class="close" aria-label="Dismiss">\u00d7</button>
    `;
    shadowRoot.appendChild(toast);

    toast.querySelector(".close").addEventListener("click", () => {
      dismissedUntil = Date.now() + DISMISS_DURATION;
      render();
    });

    document.body.appendChild(hostEl);
    setupObserver();
  }

  // Re-inject if page removes our host
  function setupObserver() {
    if (observer) observer.disconnect();
    observer = new MutationObserver(() => {
      if (!document.getElementById(HOST_ID)) {
        observer.disconnect();
        createHost();
        render();
      }
    });
    observer.observe(document.body, { childList: true });
  }

  // ── Render ─────────────────────────────────────────────────────
  function render() {
    if (!shadowRoot) return;
    const toast = shadowRoot.querySelector(".toast");
    if (!toast) return;

    const dismissed = Date.now() < dismissedUntil;
    const showOffline = currentConnected === false;
    const showNudge = currentConnected === true && currentState && currentState.sessionCount === 0;

    if (dismissed || (!showOffline && !showNudge)) {
      toast.classList.remove("visible");
      return;
    }

    const icon = toast.querySelector(".icon");
    const msg = toast.querySelector(".msg");

    if (showOffline) {
      icon.textContent = "\u26a0\ufe0f";
      msg.className = "msg offline";
      msg.textContent = "Monitor offline";
    } else {
      icon.textContent = "\ud83d\udca4";
      msg.className = "msg";
      msg.textContent = "No Claude session running \u2014 Start one?";
    }

    toast.classList.add("visible");
  }

  // ── Message handling ───────────────────────────────────────────
  chrome.runtime.onMessage.addListener((message) => {
    if (message.type === "STATE_UPDATE") {
      currentState = message.state;
      currentConnected = message.connected;
      render();
    }
  });

  // ── Init ───────────────────────────────────────────────────────
  function init() {
    createHost();
    // Request initial state from background
    chrome.runtime.sendMessage({ type: "getState" }, (response) => {
      if (chrome.runtime.lastError) return;
      if (response) {
        currentState = response.state;
        currentConnected = response.connected;
        render();
      }
    });
  }

  if (document.body) {
    init();
  } else {
    document.addEventListener("DOMContentLoaded", init);
  }
})();
