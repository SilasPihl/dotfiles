# nix-darwin/home.nix
{ config, pkgs, ... }:

with pkgs; {
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
    ".zshrc".source = "${config.home.homeDirectory}/dotfiles/zsh/.zshrc";
    ".config/kitty".source = "${config.home.homeDirectory}/dotfiles/kitty";
    ".config/nvim".source = "${config.home.homeDirectory}/dotfiles/nvim";
    ".config/nix-darwin".source = "${config.home.homeDirectory}/dotfiles/nix-darwin";
    ".config/tmux".source = "${config.home.homeDirectory}/dotfiles/tmux/.tmux.conf";
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
