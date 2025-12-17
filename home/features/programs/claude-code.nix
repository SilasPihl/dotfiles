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

  # Claude Code settings with PostToolUse hook
  claudeSettings = {
    # Enable extended thinking by default
    preferences = {
      thinkingEnabled = true;
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
    hooks = {
      Stop = [
        {
          hooks = [
            {
              type = "command";
              command = "afplay /System/Library/Sounds/Glass.aiff";
            }
          ];
        }
      ];
      SubagentStop = [
        {
          hooks = [
            {
              type = "command";
              command = "afplay /System/Library/Sounds/Glass.aiff";
            }
          ];
        }
      ];
      PreCompact = [
        {
          hooks = [
            {
              type = "command";
              command = "afplay /System/Library/Sounds/Glass.aiff";
            }
          ];
        }
      ];
    };
    statusLine = {
      type = "command";
      command = "input=$(cat); model=$(echo \"$input\" | jq -r '.model.display_name'); cwd=$(echo \"$input\" | jq -r '.workspace.current_dir'); project=$(echo \"$input\" | jq -r '.workspace.project_dir'); style=$(echo \"$input\" | jq -r '.output_style.name'); rel_path=$(echo \"$cwd\" | sed \"s|^$project||\" | sed 's|^/||'); if [ -z \"$rel_path\" ]; then rel_path=\".\"; fi; branch=$(cd \"$project\" 2>/dev/null && git branch --show-current 2>/dev/null || echo \"\"); printf \"\\033[2m%s\\033[0m \\033[36m%s\\033[0m\" \"$model\" \"$rel_path\"; if [ -n \"$branch\" ]; then printf \" \\033[35m%s\\033[0m\" \"$branch\"; fi; if [ \"$style\" != \"default\" ]; then printf \" \\033[33m[%s]\\033[0m\" \"$style\"; fi";
    };
  };

in
{
  home.packages = [ 
    claude-code 
    claude-notify
  ];

  # Create Claude Code settings directory and file
  home.file.".claude/settings.json".text = builtins.toJSON claudeSettings;
} 