{ pkgs, ... }:

{
  plugins.floaterm = {
    enable = false; # For now we disable this plugin
    width = 0.8;
    height = 0.8;
    shell = "${pkgs.zsh}/bin/zsh";
    autoinsert = true;
  };
}
