{ pkgs ? import <nixpkgs> {} }:

let
  myPackages = pkgs.buildEnv {
    name = "tools";
    paths = [
      pkgs.stow
      pkgs.neovim
      pkgs.tmux
      pkgs.yazi
      pkgs.ripgrep
      pkgs.bat
      pkgs.fzf
      pkgs.zsh
      pkgs.eza
      pkgs.zoxide
      pkgs.markdownlint-cli
      pkgs.nerdfonts.meslo-lg
      pkgs.git-credential-manager
      pkgs.direnv
    ];
  };
in
{
  env = myPackages;
}
