{ pkgs, ... }: {
  programs.zathura = {
    enable = true;

    extraConfig = ''
      set statusbar-h-padding 0
      set statusbar-v-padding 0
      set page-padding 1
      set selection-clipboard clipboard
    '';

    mappings = {
      "u" = "scroll half-up";
      "d" = "scroll half-down";
      "D" = "toggle_page_mode";
      "r" = "reload";
      "R" = "rotate";
      "K" = "zoom in";
      "J" = "zoom out";
      "i" = "recolor";
      "p" = "print";
      "g" = "goto top";

      "[fullscreen] u" = "scroll half-up";
      "[fullscreen] d" = "scroll half-down";
      "[fullscreen] D" = "toggle_page_mode";
      "[fullscreen] r" = "reload";
      "[fullscreen] R" = "rotate";
      "[fullscreen] K" = "zoom in";
      "[fullscreen] J" = "zoom out";
      "[fullscreen] i" = "recolor";
      "[fullscreen] p" = "print";
      "[fullscreen] g" = "goto top";
    };
  };
}
