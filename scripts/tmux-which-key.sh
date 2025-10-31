#!/usr/bin/env bash

# tmux-which-key.sh
# Show available tmux keybindings in a which-key style menu

set -euo pipefail

# Colors using ANSI escape codes
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
CYAN="\033[36m"

# Define keybindings with categories
# Format: "key|description|category|color"
keybinds=(
    # Window Management
    "c|Create new window|Window|$GREEN"
    "p|Previous window|Window|$GREEN"
    "n|Next window|Window|$GREEN"
    "j|Select next window (vim)|Window|$GREEN"
    "k|Select previous window (vim)|Window|$GREEN"
    "1-9|Select window by number|Window|$GREEN"
    "0|Select window 10|Window|$GREEN"
    "x|Kill window|Window|$GREEN"
    "&|Kill window (confirm)|Window|$GREEN"
    ",|Rename window|Window|$GREEN"

    # Session Management
    "s|Session switcher (sesh)|Session|$MAGENTA"
    "l|Toggle last session|Session|$MAGENTA"

    # Pane Management
    "v|Split vertical (right)|Pane|$BLUE"
    "h|Split horizontal (down)|Pane|$BLUE"
    "q|Kill pane|Pane|$BLUE"
    "M-h|Navigate left (or prev window)|Pane|$BLUE"
    "M-l|Navigate right (or next window)|Pane|$BLUE"
    "M-j|Navigate down|Pane|$BLUE"
    "M-k|Navigate up|Pane|$BLUE"
    "M-z|Toggle pane zoom|Pane|$BLUE"
    "M-e|Sync panes ON|Pane|$BLUE"
    "M-E|Sync panes OFF|Pane|$BLUE"

    # Special Features
    "C|Claude overview (find Claude sessions)|Special|$CYAN"
    "?|Show this help menu|Special|$CYAN"

    # Configuration
    "R|Reload tmux config|Config|$YELLOW"
    "M-R|Reload tmux config (no prefix)|Config|$YELLOW"
)

# Build menu with colors and nice formatting
build_menu() {
    echo -e ""
    echo -e "${BOLD}${MAGENTA}  Tmux Keybindings${RESET}"
    echo -e "${DIM}  Press any key to close${RESET}"
    echo -e ""

    local current_category=""
    for bind in "${keybinds[@]}"; do
        IFS='|' read -r key desc category color <<< "$bind"
        if [[ "$category" != "$current_category" ]]; then
            if [[ -n "$current_category" ]]; then
                echo -e ""
            fi
            echo -e "${BOLD}${YELLOW}  $category${RESET}"
            echo -e "${DIM}  ────────────────────────────────────────${RESET}"
            current_category="$category"
        fi
        printf "  ${color}${BOLD}%-14s${RESET}  ${DIM}%s${RESET}\n" "$key" "$desc"
    done
    echo -e ""
}

# Show menu using less for better display
show_menu() {
    build_menu | less -R +Gg
}

show_menu

