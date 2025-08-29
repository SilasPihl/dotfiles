{ pkgs, user, ... }:

{
  programs.zsh.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "Silas Pihl";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
