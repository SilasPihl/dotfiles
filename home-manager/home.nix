{ config, pkgs, inputs, ... }:

{
  home.username = "sebastianballe";
  home.homeDirectory = "/Users/sebastianballe";
  home.stateVersion = "24.05";

  home.file = {

    # Files and directories directly in ~/
    ".tmux.conf".source = ~/dotfiles/tmux/.tmux.conf;
    ".tmux".source = ~/dotfiles/tmux/.tmux;

    # Directories in ~/.config/
    ".config/nvim".source = ~/dotfiles/nvim;
    ".config/kitty".source = ~/dotfiles/kitty;
    ".config/bat".source = ~/dotfiles/bat;
    ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
  };

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
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

  catppuccin.flavor = "macchiato";
  catppuccin.accent = "mauve";


  programs = {

    home-manager = {
      enable = true;
    };

  };

}
