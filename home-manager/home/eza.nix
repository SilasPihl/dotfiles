{ config, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = true;
    extraOptions = [
      "--no-user"
      "--long"
      "--no-permissions"
      "--no-filesize"
    ];
  };
}
