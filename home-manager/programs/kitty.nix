{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Lato";
      size = 14;
    };
    extraConfig = ''
      background_opacity 0.95
      hide_window_decorations yes
      window_border_width 0
      draw_minimal_borders yes
    '';
    settings = {
      # Window borders
      active_border_color = "#3d59a1";
      inactive_border_color = "#101014";
      bell_border_color = "#e0af68";

      # Tab bar
      tab_bar_style = "fade";
      tab_fade = 1;
      active_tab_foreground = "#3d59a1";
      active_tab_background = "#16161e";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "#787c99";
      inactive_tab_background = "#16161e";
      inactive_tab_font_style = "bold";
      tab_bar_background = "#101014";

      # Colors
      background = "#24283b";
      cursor_text_color = "#24283b";
      active_tab_background = "#1f2335";
      inactive_tab_background = "#1f2335";
    };
    keybindings = {
      "alt+left" = "send_text all \\x1b\\x62";
      "alt+right" = "send_text all \\x1b\\x66";
    };
  };
}
