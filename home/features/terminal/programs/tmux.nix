{pkgs, ...}: {
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
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.catppuccin;

        extraConfig = ''
          set -g @catppuccin_flavor "macchiato"
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator ""
          set -g @catppuccin_window_middle_separator " █"
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
      # Status bar settings
      set -g status-position top
      set -g status-interval 1
      set -g status-justify left
      set -g renumber-windows on
      set -g set-clipboard on

      # Navigation
      bind-key n next-window
      bind-key p previous-window

      set -g detach-on-destroy off
      bind-key x kill-pane
    '';
  };
}
