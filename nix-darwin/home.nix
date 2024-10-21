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
    userEmail = "sbal@lix.one";

    aliases = {
      ls = "eza --color=auto --long --no-filesize --icons=always --no-time --almost-all";
      v = "nvim";
      c = "clear";
      cd = "z";
      python = "python3";
      tf = "terraform";
      gcl = "gitlab-ci-local";
      cat = "bat";
      y = "yazi";
      dark = "~/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh dark";
      light = "~/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh light";
      lg = "lazygit";
      ld = "lazydocker";
      ta = "tmux attach -t";
      tn = "tmux new-session -s ";
      tk = "tmux kill-session -t ";
      tl = "mux list-sessions";
      td = "tmux detach";
      tc = "clear; tmux clear-history; clear";
    };
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
