{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-s";
    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 1000000;
    terminal = "screen-256color";
    resizeAmount = 5;
    sensibleOnTop = false;

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "macchiato"
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator ""
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
          set -g @catppuccin_status_modules_right "directory date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
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
      # Unbind and rebind keys
      unbind r
      bind r source-file ~/.tmux.conf

      # Split windows and pane navigation
      bind t split-window -h
      bind v split-window -v
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Pane resizing
      unbind C-l
      unbind -T root C-l
      bind -r C-h resize-pane -L 5
      bind -r C-j resize-pane -D 5
      bind -r C-k resize-pane -U 5
      bind -r C-l resize-pane -R 5

      # Status bar settings
      set -g status-position top
      set -g status-interval 1
      set -g status-justify left
      set -g renumber-windows on
      set -g set-clipboard on
    '';
  };
}
