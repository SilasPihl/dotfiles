{ config, pkgs, ... }:

{

  environment.systemPackages =
    [ pkgs.vim
      pkgs.bat
      pkgs.eza
      pkgs.tmux
      pkgs.neovim
      pkgs.fzf
      pkgs.zoxide
      pkgs.thefuck
      pkgs.direnv
    ];

  homebrew = {
    enable = true;

    casks = [
      # "1password"
      "slack"
      # "obsidian"
      pkgs.fzf
      pkgs.zoxide
      pkgs.thefuck
      pkgs.direnv
      "raycast"
      # "kitty"
    ];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
