{{ pkgs ? import <nixpkgs> {} }:

{
  packageOverrides = pkgs: {
    myPackages = pkgs.buildEnv {
      name = "balle-tools";
      paths = with pkgs; [
        stow
        neovim
        tmux
        yazi
        ripgrep
        bat
      ];
    };
  };
