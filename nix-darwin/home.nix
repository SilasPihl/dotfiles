{ config, pkgs, ... }:

{
  home.username = "sebastianballe";
  home.stateVersion = "23.05";  # Required for home-manager compatibility, can be updated with the correct version.

  home.file = {
    ".zshrc".source = ~/dotfiles/zsh/.zshrc;
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };

}
