#!/usr/bin/env bash
# tmux-claude-overview.sh
# Find and overview all tmux panes running Claude (named "claude")

set -euo pipefail

# Function to get pane info
get_claude_panes() {
    # List all panes from sessions named "claude" that are running node (Claude Code)
    # Format: session:window.pane window_name pane_title path command
    tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{window_name} #{pane_title} #{pane_current_path} #{pane_current_command}" | \
        grep "^claude:" | grep " node$" || true
}

# Function to capture pane output with more lines
capture_pane_output() {
    local target=$1
    # Capture last 50 lines of pane content
    tmux capture-pane -t "$target" -p -S -50 || echo "[Unable to capture pane output]"
}

# Function to detect if Claude is waiting for input
detect_status() {
    local target=$1
    local last_lines=$(tmux capture-pane -t "$target" -p | tail -n 5)

    # Check for common waiting patterns
    if echo "$last_lines" | grep -qE '\(y/n\)|\(yes/no\)|\? *$|Continue\?|Proceed\?|Should I|confirm'; then
        echo "⏳"
    elif echo "$last_lines" | grep -qE 'Ionizing|Running|Building'; then
        echo "⚡"
    else
        echo "✓"
    fi
}

# Main function
main() {
    local claude_panes
    claude_panes=$(get_claude_panes)

    if [ -z "$claude_panes" ]; then
        echo "No Claude panes found (searching for panes named 'claude')"
        exit 0
    fi

    # Build fzf input with preview as a formatted table
    local fzf_input
    fzf_input=$(while IFS= read -r pane_line; do
        local target=$(echo "$pane_line" | awk '{print $1}')
        local window_name=$(echo "$pane_line" | awk '{print $2}')
        # Get pane title (may contain spaces) - everything from field 3 to second-to-last field
        local pane_title=$(echo "$pane_line" | awk '{for(i=3;i<NF-1;i++) printf "%s ", $i; print $(NF-1)}')
        local path=$(echo "$pane_line" | awk '{print $(NF-1)}')
        local command=$(echo "$pane_line" | awk '{print $NF}')

        # Extract project name from path (last directory)
        local project=$(basename "$path")

        # Clean up pane title - remove leading ✳ symbol
        local clean_title=$(echo "$pane_title" | sed 's/^✳ *//')

        # Detect status
        local status=$(detect_status "$target")

        # Format as table: Status | Window:Pane | Task | Project | [hidden: full target for selection]
        printf "%s │ %-15s │ %-30s │ %-20s │ %s\n" "$status" "$window_name:${target##*.}" "$clean_title" "$project" "$target"
    done <<< "$claude_panes")

    # Use fzf for selection with preview
    local selected
    selected=$(echo "$fzf_input" | fzf \
        --layout=reverse \
        --cycle \
        --preview-window=right:70%:wrap:+150 \
        --ansi \
        --preview='tmux capture-pane -t $(echo {} | awk -F"│" "{print \$5}" | xargs) -p -e -S - | grep -v "^[[:space:]]*$" | tail -n 200 | bat --color=always --style=plain' \
        --header="  │ Window:Pane     │ Task                           │ Project" \
        --bind='ctrl-r:reload(bash -c '\''source <(declare -f detect_status); tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{window_name} #{pane_title} #{pane_current_path} #{pane_current_command}" | grep "^claude:" | grep " node$" | while IFS= read -r line; do target=$(echo "$line" | awk "{print \$1}"); window_name=$(echo "$line" | awk "{print \$2}"); pane_title=$(echo "$line" | awk "{for(i=3;i<NF-1;i++) printf \"%s \", \$i; print \$(NF-1)}"); path=$(echo "$line" | awk "{print \$(NF-1)}"); project=$(basename "$path"); clean_title=$(echo "$pane_title" | sed "s/^✳ *//"); status=$(detect_status "$target"); printf "%s │ %-15s │ %-30s │ %-20s │ %s\n" "$status" "$window_name:${target##*.}" "$clean_title" "$project" "$target"; done'\'')' \
        || true)

    if [ -n "$selected" ]; then
        # Extract the hidden target from the last column
        local target=$(echo "$selected" | awk -F'│' '{print $5}' | xargs)
        local session=$(echo "$target" | cut -d: -f1)
        local window_pane=$(echo "$target" | cut -d: -f2)
        local window=$(echo "$window_pane" | cut -d. -f1)
        local pane=$(echo "$window_pane" | cut -d. -f2)

        # Switch to the session and select the window and pane
        tmux switch-client -t "$session"
        tmux select-window -t "$session:$window"
        tmux select-pane -t "$session:$window.$pane"
    fi
}

# If run with --list flag, just show the list without fzf
if [ "${1:-}" = "--list" ]; then
    claude_panes=$(get_claude_panes)
    if [ -z "$claude_panes" ]; then
        echo "No Claude panes found"
        exit 0
    fi

    echo "Found Claude instances:"
    echo "======================="
    while IFS= read -r pane_line; do
        target=$(echo "$pane_line" | awk '{print $1}')
        title=$(echo "$pane_line" | cut -d' ' -f2-)
        echo ""
        echo "Pane: $target"
        echo "Title: $title"
        echo "---"
        echo "Last output:"
        capture_pane_output "$target" | tail -n 20
        echo ""
    done <<< "$claude_panes"
else
    main
fi