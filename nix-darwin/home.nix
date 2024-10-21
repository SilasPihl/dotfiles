{ config, pkgs, ... }:

{
  home.username = "sebastianballe";
  home.homeDirectory = "/Users/sebastianballe";
  home.stateVersion = "24.05";

  home.file = {

    # Files and directories directly in ~/
    ".zshrc".source = ~/dotfiles/zsh/.zshrc;
    ".zshrc-git".source = ~/dotfiles/zsh/.zshrc-git;
    ".tmux.conf".source = ~/dotfiles/tmux/.tmux.conf;
    ".tmux".source = ~/dotfiles/tmux/.tmux;

    # Directories in ~/.config/
    ".config/nvim".source = ~/dotfiles/nvim;
    ".config/yazi".source = ~/dotfiles/yazi;
    ".config/kitty".source = ~/dotfiles/kitty;
    ".config/bat".source = ~/dotfiles/bat;
    ".config/direnv".source = ~/dotfiles/direnv;
    ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
  };

  programs.home-manager.enable = true;


  programs.git = {
    enable = true;
    userName = "Sebastian Balle";
    userEmail = "s.balle@sbconsultancy.dk";

    aliases = {
      st = "status";
    };

    includes = [
      {
        path = "~/.gitconfig-leo";
        condition = "gitdir:~/git/leopharma/";
      }
      {
        path = "~/.gitconfig-genmab";
        condition = "gitdir:~/git/genmab/";
      }
      {
        path = "~/.gitconfig-lix";
        condition = "gitdir:~/git/lix/";
      }
    ];
  };

  programs.zsh = {
    enable = true;

    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };


}
