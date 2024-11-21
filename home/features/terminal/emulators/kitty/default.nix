{ pkgs, user, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "Lato";
      size = 14;
    };

    extraConfig = ''
      background_opacity 0.98
      hide_window_decorations yes
      window_border_width 0
      draw_minimal_borders yes
    '';

    settings = {
      tab_bar_style = "fade";
      tab_bar_background = "#101014";
      active_tab_foreground = "#3d59a1";
      active_tab_background = "#16161e";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "#787c99";
      inactive_tab_background = "#16161e";
      inactive_tab_font_style = "bold";
      tab_bar_min_tabs = 1;
      tab_title_template = "{index}";
    };

    keybindings = {
      "cmd+shift+right" = "next_tab";
      "cmd+shift+left" = "previous_tab";
      "cmd+t" = "new_tab";
      "cmd+w" = "close_tab";
    };

    themeFile = "Catppuccin-Macchiato";
  };
}
