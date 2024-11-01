{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
    # TODO: Add theme located in dotfiles/themes/bat/Macchiato.tmTheme
    # config = {
    #   theme = "Catppuccin Macchiato";
    # };
  };
}
