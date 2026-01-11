# Claude Blocker - Development Hub Extension Roadmap

## Current State (v1.0)
- TypeScript server tracking Claude Code sessions via hooks
- HTTP API: `GET /status`, `POST /hook`
- WebSocket: `ws://localhost:8765/ws` for real-time updates
- Session states: `idle`, `working`, `waiting_for_input`

---

## Phase 1: Basic Chrome Extension (MVP)
Simple extension showing Claude session status.

**Features:**
- [ ] Badge color: green (idle/free), red (working), yellow (waiting for input)
- [ ] Popup showing active sessions with status
- [ ] Desktop notification when Claude needs input

**Tech:**
- Manifest V3
- Service worker for WebSocket connection
- Simple popup UI

---

## Phase 2: Enhanced Notifications
Better awareness of Claude sessions needing attention.

**Features:**
- [ ] Sound notification option (configurable)
- [ ] "Time waiting" indicator - how long Claude has been waiting for input
- [ ] Session details in popup (cwd, duration)
- [ ] Click session to copy terminal focus command

---

## Phase 3: Multi-Source Notification Hub
Extend beyond Claude to become a dev notification center.

**Potential integrations:**

### GitHub
- PR review requests
- CI/CD status (GitHub Actions)
- Mentions in issues/PRs
- Release notifications

**Implementation options:**
1. GitHub API polling (simple, rate-limited)
2. Local webhook server (more complex, real-time)
3. GitHub CLI (`gh`) integration

### Other ideas
- Slack mentions
- Linear/Jira ticket assignments
- Build status (local dev servers)
- Calendar reminders for standup/meetings

---

## Phase 4: Advanced Features

**Session Management:**
- [ ] Kill/restart Claude sessions from extension
- [ ] Session history and analytics
- [ ] Cost tracking across sessions

**Smart Notifications:**
- [ ] "Focus mode" - batch notifications
- [ ] Priority levels for different notification types
- [ ] Snooze functionality

**Cross-device:**
- [ ] Sync notification preferences
- [ ] Mobile companion app (push notifications)

---

## Architecture Ideas

```
┌─────────────────────────────────────────────────────┐
│                 Chrome Extension                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │
│  │   Claude    │  │   GitHub    │  │   Other     │ │
│  │   Status    │  │   Notifs    │  │   Sources   │ │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘ │
└─────────┼────────────────┼────────────────┼─────────┘
          │                │                │
          ▼                ▼                ▼
   ws://localhost:8765  API/webhook    future servers
          │                │                │
          ▼                ▼                ▼
┌─────────────────┐ ┌─────────────┐ ┌─────────────────┐
│ Claude Blocker  │ │ GH Listener │ │ Other Services  │
│    Server       │ │   Server    │ │                 │
└─────────────────┘ └─────────────┘ └─────────────────┘
```

---

## Notes
- Keep extension lightweight - offload logic to local servers
- Use consistent WebSocket message format across all sources
- Consider unified notification API for all sources
