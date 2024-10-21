{ config, pkgs, lib, ... }:

{
  home.username = "sebastianballe";
  home.homeDirectory = lib.mkForce "/Users/sebastianballe";  # Use lib.mkForce to prioritize this definition
  home.stateVersion = "23.05";  # Adjust based on your Nix and home-manager version

  # Use config.home.homeDirectory instead of hardcoding paths
  home.file = {
    ".zshrc".source = "${config.home.homeDirectory}/dotfiles/zsh/.zshrc";
    ".config/kitty".source = "${config.home.homeDirectory}/dotfiles/kitty";
    ".config/nvim".source = "${config.home.homeDirectory}/dotfiles/nvim";
    ".config/nix-darwin".source = "${config.home.homeDirectory}/dotfiles/nix-darwin";
    ".config/tmux".source = "${config.home.homeDirectory}/dotfiles/tmux/.tmux.conf";
  };

  home.packages = [
    pkgs.bat
    pkgs.fzf
    pkgs.tmux
    pkgs.vim
    pkgs.direnv
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
}
