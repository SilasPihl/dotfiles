# nix-darwin/home.nix
{ config, pkgs, ... }:

with pkgs; {  # Apply `with pkgs` here to allow package references without `pkgs.`
  home.username = "sebastianballe";
  home.homeDirectory = "/Users/sebastianballe";
  home.stateVersion = "23.05";  # Adjust based on your Nix and home-manager version

  # User-specific packages
  home.packages = [
    bat
    fzf
    tmux
    vim
    direnv
  ];

  home.file = {
    ".zshrc".source = ~/dotfiles/zsh/.zshrc;
    ".config/kitty".source = ~/dotfiles/kitty;
    ".config/nvim".source = ~/dotfiles/nvim;
    ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
    ".config/tmux".source = ~/dotfiles/tmux/.tmux.conf;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    PATH = "${config.home.homeDirectory}/.nix-profile/bin:${config.home.sessionPath}";
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

  # Enable home-manager programs
  programs.home-manager.enable = true;
}
