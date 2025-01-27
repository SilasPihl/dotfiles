{ pkgs, ... }:
let
  theme = ../../../../themes/bat;
in
{
  programs.bat = {
    enable = false;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
    config = {
      theme = "macchiato";
    };
    themes = {
      macchiato = {
        src = theme;
        file = "Macchiato.tmTheme";
      };
    };
  };
}