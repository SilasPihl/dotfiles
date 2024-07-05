{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "balle-tools";
      paths = [
      	stow
        neovim
	tmux
	yazi
	ripgrep
	bat
      ];
    };
  };
}
