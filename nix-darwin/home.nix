# nix-darwin/home.nix
{ config, pkgs, lib, ... }:

with pkgs; {
  home.username = "sebastianballe";
  home.homeDirectory = "/Users/sebastianballe";
  home.stateVersion = "23.05";

  home.packages = [
    bat
    fzf
    tmux
    vim
    direnv
  ];

  home.file = {
    ".zshrc".source = "${config.home.homeDirectory}/dotfiles/zsh/.zshrc";  # Dynamically resolve home directory
    ".config/kitty".source = "${config.home.homeDirectory}/dotfiles/kitty";
    ".config/nvim".source = "${config.home.homeDirectory}/dotfiles/nvim";
    ".config/nix-darwin".source = "${config.home.homeDirectory}/dotfiles/nix-darwin";
    ".config/tmux".source = "${config.home.homeDirectory}/dotfiles/tmux/.tmux.conf";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    PATH = lib.mkForce "${config.home.homeDirectory}/.nix-profile/bin:${builtins.concatStringsSep ":" config.home.sessionPath}";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs.zsh = {
    enable = true;
    initExtra = ''
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };

  programs.home-manager.enable = true;
}
