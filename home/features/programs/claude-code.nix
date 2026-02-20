{ pkgs, claude-code, lib, ... }:

let
  # Notification script for Claude Code
  claude-notify = pkgs.writeShellScriptBin "claude-notify" ''
    #!/bin/bash
    
    # Get tool name and result from arguments
    TOOL_NAME="''${1:-Task}"
    RESULT="''${2:-Completed}"
    
    # Get current time
    TIME=$(date +"%H:%M")
    
    # Send notification using AppleScript
    osascript <<EOF
    display notification "$TOOL_NAME completed at $TIME" with title "Claude Code" sound name "Glass"
EOF
  '';

  # Claude Blocker server startup script
  # Run the pre-built TypeScript server from the dotfiles repo
  claude-blocker = pkgs.writeShellScriptBin "claude-blocker" ''
    #!/bin/bash
    BLOCKER_DIR="$HOME/repos/dotfiles/home/features/programs/claude-blocker"

    # Check if dist exists, if not build it
    if [ ! -d "$BLOCKER_DIR/dist" ]; then
      echo "Building claude-blocker..."
      cd "$BLOCKER_DIR" && npm install && npm run build
    fi

    exec ${pkgs.nodejs_22}/bin/node "$BLOCKER_DIR/dist/index.js" "$@"
  '';

  # Status line script for Claude Code (robbyrussell-style with metrics)
  claude-statusline = pkgs.writeShellScriptBin "claude-statusline" ''
    #!/bin/bash

    # Read JSON input from stdin
    input=$(cat)

    # Get current directory (basename)
    cwd=$(echo "$input" | jq -r '.workspace.current_dir')
    dir=$(basename "$cwd")

    # Get model name
    model=$(echo "$input" | jq -r '.model.display_name')

    # Arrow symbol
    printf "→  "

    # Directory in cyan
    printf "\033[36m%s\033[0m " "$dir"

    # Git info if in a repo
    if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
      branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || echo "detached")

      # Check for uncommitted changes
      if ! git -C "$cwd" --no-optional-locks diff-index --quiet HEAD -- 2>/dev/null; then
        dirty="✗"
      else
        dirty=""
      fi

      printf "git:(\033[31m%s\033[0m) " "$branch"
      if [ -n "$dirty" ]; then
        printf "\033[33m%s\033[0m " "$dirty"
      fi
    fi

    # Separator
    printf "\033[2m|\033[0m "

    # Context window usage percentage (using current_usage, not cumulative total)
    size=$(echo "$input" | jq -r '.context_window.context_window_size')
    usage=$(echo "$input" | jq '.context_window.current_usage')
    if [ "$usage" != "null" ] && [ "$size" != "null" ] && [ "$size" -gt 0 ]; then
      # Current context = input_tokens + cache tokens (both creation and read count toward context)
      current_tokens=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
      pct=$((current_tokens * 100 / size))
      printf "\033[33m%d%%\033[0m " "$pct"
    else
      printf "\033[33m0%%\033[0m "
    fi

    # Separator
    printf "\033[2m|\033[0m "

    # Cost in USD
    cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
    printf "\033[32m\$%.2f\033[0m " "$cost"

    # Separator
    printf "\033[2m|\033[0m "

    # Input/output tokens (formatted as K)
    in_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
    out_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
    in_k=$(awk "BEGIN {printf \"%.1f\", $in_tokens / 1000}")
    out_k=$(awk "BEGIN {printf \"%.1f\", $out_tokens / 1000}")
    printf "\033[2min:%sK out:%sK\033[0m " "$in_k" "$out_k"

    # Separator
    printf "\033[2m|\033[0m "

    # Session duration
    duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
    duration_s=$((duration_ms / 1000))
    mins=$((duration_s / 60))
    secs=$((duration_s % 60))
    printf "\033[2m%dm%02ds\033[0m " "$mins" "$secs"

    # Separator
    printf "\033[2m|\033[0m "

    # Model name (dimmed)
    printf "\033[2m%s\033[0m" "$model"
  '';

  # Claude Code settings with PostToolUse hook
  claudeSettings = {
    # Enable extended thinking by default
    preferences = {
      thinkingEnabled = true;
    };
    # Status line configuration
    statusLine = {
      type = "command";
      command = "${claude-statusline}/bin/claude-statusline";
    };
    # MCP servers for documentation lookup
    mcpServers = {
      context7 = {
        command = "npx";
        args = [ "-y" "@upstash/context7-mcp@latest" ];
      };
      next-devtools = {
        command = "npx";
        args = [ "-y" "next-devtools-mcp@latest" ];
      };
    };
    # Claude Blocker hooks - send session state to localhost server
    # Start the server with: claude-blocker
    # Check status with: curl http://localhost:8765/status
    hooks = {
      SessionStart = [{
        hooks = [{
          type = "command";
          command = "curl -s -X POST http://localhost:8765/hook -H 'Content-Type: application/json' -d \"$(cat)\" > /dev/null 2>&1 &";
        }];
      }];
      SessionEnd = [{
        hooks = [{
          type = "command";
          command = "curl -s -X POST http://localhost:8765/hook -H 'Content-Type: application/json' -d \"$(cat)\" > /dev/null 2>&1 &";
        }];
      }];
      UserPromptSubmit = [{
        hooks = [{
          type = "command";
          command = "curl -s -X POST http://localhost:8765/hook -H 'Content-Type: application/json' -d \"$(cat)\" > /dev/null 2>&1 &";
        }];
      }];
      PreToolUse = [{
        matcher = "*";
        hooks = [{
          type = "command";
          command = "curl -s -X POST http://localhost:8765/hook -H 'Content-Type: application/json' -d \"$(cat)\" > /dev/null 2>&1 &";
        }];
      }];
      PostToolUse = [{
        matcher = "*";
        hooks = [{
          type = "command";
          command = "curl -s -X POST http://localhost:8765/hook -H 'Content-Type: application/json' -d \"$(cat)\" > /dev/null 2>&1 &";
        }];
      }];
      Stop = [{
        hooks = [{
          type = "command";
          command = "curl -s -X POST http://localhost:8765/hook -H 'Content-Type: application/json' -d \"$(cat)\" > /dev/null 2>&1 &";
        }];
      }];
    };
    permissions = {
      allow = [
        "mcp__playwright__browser_type"
        "mcp__playwright__browser_click"
        "mcp__playwright__browser_console_messages"
        "mcp__playwright__browser_wait_for"
        "mcp__playwright__browser_close"
        "mcp__playwright__browser_navigate"
        "mcp__playwright__browser_select_option"
        "mcp__playwright__browser_press_key"
        "mcp__playwright__browser_snapshot"
        "Bash(npm run test:e2e:mock:*)"
        "Bash(npm run test:e2e:fast:*)"
        "Bash(npm run test:e2e:*)"
        "Bash(git merge-base:*)"
        "Bash(gh:*)"
        "Bash(npm run check-types:*)"
        "Bash(git fetch:*)"
        "Bash(git show:*)"
        "WebFetch(domain:raw.githubusercontent.com)"
        "Bash(npm run:*)"
        "Bash(npx tsc:*)"
        "Bash(npx eslint:*)"
        "Bash(sed:*)"
        "Bash(cat:*)"
        "Bash(mkdir:*)"
        "Bash(npm run lint:fix :*)"
        "Bash(npm run format:fix :*)"
        "Bash(npm run lint:*)"
        "Bash(npm install)"
        "Bash(npx prettier :*)"
        "Bash(npx prettier:*)"
        "Bash(cp:*)"
        "Bash(cd :*)"
        "Bash(find :*)"
        "Bash(gh pr view:*)"
        "Bash(gh api:*)"
        "Bash(git rev-parse:*)"
        "Bash(gh pr list:*)"
        "Bash(gh pr edit:*)"
        "Bash(grep:*)"
        "Bash(find:*)"
        "Bash(rg:*)"
        "Bash(ls:*)"
        "Bash(git add:*)"
        "Bash(task:*)"
        "Bash(chmod:*)"
        "Bash(curl:*)"
        "Bash(go run:*)"
        "Bash(az logout:*)"
        "Bash(rm:*)"
        "Bash(ln:*)"
        "Bash(docker exec:*)"
        "Bash(tilt logs:*)"
        "Bash(tilt trigger:*)"
        "Bash(tilt up:*)"
        "Bash(true)"
        "WebSearch"
        "Bash(task backend:auth-service:build)"
        "Bash(task backend:auth-service:integration-test)"
        "Bash(task backend:auth-service:lint)"
        "Bash(task backend:auth-service:run)"
        "Bash(task backend:auth-service:tidy)"
        "Bash(task backend:auth-service:unit-test)"
        "Bash(task backend:demo-service:build)"
        "Bash(task backend:demo-service:lint)"
        "Bash(task backend:demo-service:run)"
        "Bash(task backend:demo-service:tidy)"
        "Bash(task backend:file-service:build)"
        "Bash(task backend:file-service:integration-test)"
        "Bash(task backend:file-service:lint)"
        "Bash(task backend:file-service:run)"
        "Bash(task backend:file-service:tidy)"
        "Bash(task backend:file-service:unit-test)"
        "Bash(task backend:invoice-service:build)"
        "Bash(task backend:invoice-service:integration-test)"
        "Bash(task backend:invoice-service:lint)"
        "Bash(task backend:invoice-service:run)"
        "Bash(task backend:invoice-service:tidy)"
        "Bash(task backend:invoice-service:unit-test)"
        "Bash(task backend:lint-all)"
        "Bash(task backend:lix-cli:build)"
        "Bash(task backend:lix-cli:integration-test)"
        "Bash(task backend:lix-cli:lint)"
        "Bash(task backend:lix-cli:run)"
        "Bash(task backend:lix-cli:tidy)"
        "Bash(task backend:lix-cli:unit-test)"
        "Bash(task backend:org-service:build)"
        "Bash(task backend:org-service:integration-test)"
        "Bash(task backend:org-service:lint)"
        "Bash(task backend:org-service:run)"
        "Bash(task backend:org-service:tidy)"
        "Bash(task backend:org-service:unit-test)"
        "Bash(task backend:scaffold-service)"
        "Bash(task backend:tidy-all)"
        "Bash(task cloud-server:connect)"
        "Bash(task cloud-server:download)"
        "Bash(task cloud-server:download-kubeconfig)"
        "Bash(task cloud-server:upload)"
        "Bash(task compose:down)"
        "Bash(task compose:ps)"
        "Bash(task compose:up)"
        "Bash(task docs:build)"
        "Bash(task docs:serve)"
        "Bash(task frontend:admin-portal:build)"
        "Bash(task frontend:admin-portal:run)"
        "Bash(task frontend:bank-portal:build)"
        "Bash(task frontend:bank-portal:run)"
        "Bash(task frontend:insurance-portal:build)"
        "Bash(task frontend:insurance-portal:run)"
        "Bash(task frontend:landing-page:build)"
        "Bash(task frontend:landing-page:run)"
        "Bash(task frontend:shared:common:build)"
        "Bash(task frontend:shared:protobase:build)"
        "Bash(task frontend:shared:ui:build)"
        "Bash(task frontend:supplier-portal:build)"
        "Bash(task frontend:supplier-portal:run)"
        "Bash(task kube:bootstrap)"
        "Bash(task platform:check)"
        "Bash(claude doctor)"
        "Bash(go build:*)"
        "Bash(go work:*)"
      ];
      deny = [ ];
    };
  };

in
{
  home.packages = [
    claude-code
    claude-notify
    claude-statusline
    claude-blocker
  ];

  # Create Claude Code settings directory and file
  home.file.".claude/settings.json".text = builtins.toJSON claudeSettings;
} 