// Dev Hub - Popup Script

function render() {
  chrome.runtime.sendMessage({ type: "getState" }, (response) => {
    const { state, connected } = response || { state: null, connected: false };
    const statusDot = document.getElementById("statusDot");
    const content = document.getElementById("content");

    if (!connected) {
      statusDot.className = "status-dot offline";
      content.innerHTML = `
        <div class="section">
          <div class="section-header">Claude</div>
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

    const idle = state.sessions - state.working - state.waitingForInput;

    content.innerHTML = `
      <div class="section">
        <div class="section-header">Claude</div>
        <div class="stats">
          <div class="stat">
            <div class="stat-label">Sessions</div>
            <div class="stat-value">${state.sessions}</div>
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
      </div>
    `;
  });
}

// Refresh button handler
document.getElementById("refreshBtn").addEventListener("click", (e) => {
  const btn = e.target;
  btn.classList.add("spinning");

  // Tell background to reconnect
  chrome.runtime.sendMessage({ type: "reconnect" }, () => {
    setTimeout(() => {
      btn.classList.remove("spinning");
      render();
    }, 500);
  });
});

// Initial render
render();
