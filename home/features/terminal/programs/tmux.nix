{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-s";
    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 1000000;
    terminal = "tmux-256color";
    sensibleOnTop = false;
    resizeAmount = 5;

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.catppuccin;

        extraConfig = ''
          set -g @catppuccin_flavor "macchiato"
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator ""
          set -g @catppuccin_window_middle_separator "█"
          set -g @catppuccin_window_text "#W"
          set -g @catppuccin_window_current_text "#W"
          set -g @catppuccin_status_modules_right "directory date_time"
          set -g @catppuccin_status_left_separator " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_menu_selected_style "fg=#{@thm_surface_0},bg=#{@thm_yellow}"
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60'
        '';
      }
    ];


    extraConfig = ''
        # Window management with leader key + vim motions
        # Create new window
        bind c new-window -c "#{pane_current_path}"
        
        # Navigate windows with vim keys
        bind p previous-window
        bind n next-window
        bind j select-window -t :-
        bind k select-window -t :+
        
        # Quick window switching by number
        bind 1 select-window -t 1
        bind 2 select-window -t 2
        bind 3 select-window -t 3
        bind 4 select-window -t 4
        bind 5 select-window -t 5
        bind 6 select-window -t 6
        bind 7 select-window -t 7
        bind 8 select-window -t 8
        bind 9 select-window -t 9
        bind 0 select-window -t 10
        
        # Window operations
        bind s run-shell "sesh connect \"\$(
          sesh list --icons | fzf-tmux -p 80%,70% \
            --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
            --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
            --bind 'tab:down,btab:up' \
            --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
            --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
            --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
            --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
            --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
            --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
            --preview-window 'right:55%' \
            --preview 'sesh preview {}'
        )\""
        
        # Toggle between last two sessions
        bind l switch-client -l
        bind , command-prompt -I "#W" "rename-window '%%'"
        bind x kill-window
        bind & kill-window
        
        # Split windows with vim-like keys
        bind v split-window -h -c "#{pane_current_path}"
        bind h split-window -v -c "#{pane_current_path}"
        
        # Kill current pane without confirmation
        bind q kill-pane
        
        # Break pane to new window and join pane from window
        bind b break-pane -d
        bind J choose-window "join-pane -h -s %%"
        
        # Create new window with specific name for agents
        bind A command-prompt -p "Agent name:" "new-window -n 'agent-%%' -c '#{pane_current_path}'"
        
        # Move current window to different position
        bind M command-prompt -p "Move window to:" "move-window -t %%"

        # Claude overview - find all Claude panes
        bind C display-popup -E -w 90% -h 90% "~/repos/dotfiles/scripts/tmux-claude-overview.sh"

        # Which-key style help menu
        bind ? display-popup -E -w 70 -h 70% -b rounded "~/repos/dotfiles/scripts/tmux-which-key.sh"

        # Pane navigation (keeping your existing Alt+vim keys)
        bind -n M-h run-shell "if [ $(tmux display-message -p '#{pane_at_left}') -ne 1 ]; then tmux select-pane -L; else tmux select-window -p; fi"
        bind -n M-l run-shell "if [ $(tmux display-message -p '#{pane_at_right}') -ne 1 ]; then tmux select-pane -R; else tmux select-window -n; fi"
        bind -n M-j run-shell "if [ $(tmux display-message -p '#{pane_at_bottom}') -ne 1 ]; then tmux select-pane -D; fi"
        bind -n M-k run-shell "if [ $(tmux display-message -p '#{pane_at_top}') -ne 1 ]; then tmux select-pane -U; fi"
        bind -n M-z run-shell "tmux resize-pane -Z"
        
        # Reload tmux config
        bind R source-file ~/.config/tmux/tmux.conf \; display "Configuration reloaded"
        bind -n M-R source-file ~/.config/tmux/tmux.conf \; display "Configuration reloaded"

        # Toggles to sync panes
        bind -n M-e setw synchronize-panes on \; display "Sync is ON"
        bind -n M-E setw synchronize-panes off \; display "Sync is OFF"

        # Apply Tc
        set -ga terminal-overrides ",xterm-256color:RGB:smcup@:rmcup@"

        # Enable focus-events
        set -g focus-events on

        # Set default escape-time
        set-option -sg escape-time 10

        set-option -g status-position bottom
        
        # Disable automatic renaming of windows
        set-option -g allow-rename off
        set-option -g automatic-rename off
      '';
  };
}