{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "tools";
      paths = [
        stow
        neovim
        tmux
        yazi
        ripgrep
        bat
        fzf
      ];
    };
  };
}
