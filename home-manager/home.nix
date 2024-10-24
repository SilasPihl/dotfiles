{ config, pkgs, ... }:

{
  home.username = "sebastianballe";
  home.homeDirectory = "/Users/sebastianballe";
  home.stateVersion = "24.05";

  home.file = {
    ".tmux.conf".source = ~/dotfiles/tmux/.tmux.conf;
    ".tmux".source = ~/dotfiles/tmux/.tmux;

    ".config/nvim".source = ~/dotfiles/nvim;
    ".config/kitty".source = ~/dotfiles/kitty;
    ".config/bat".source = ~/dotfiles/bat;
    ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
  };

  imports = [
    # No need to import the global Catppuccin module here
    ./home/bat.nix
    ./home/btop.nix
    ./home/direnv.nix
    ./home/eza.nix
    ./home/fzf.nix
    ./home/git.nix
    ./home/ripgrep.nix
    ./home/tmux.nix
    ./home/yazi.nix
    ./home/zoxide.nix
    ./home/zsh.nix
  ];

  programs = {
    home-manager = {
      enable = true;
    };
  };

  # You can manually apply the Catppuccin theme for each application here
}
