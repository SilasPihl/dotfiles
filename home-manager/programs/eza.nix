{ pkgs, ... }:

{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    extraOptions = [
      "--no-user"
      "--long"
      "--no-permissions"
      "--no-filesize"
    ];
  };
}
