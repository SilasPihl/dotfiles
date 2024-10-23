{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestion = {
      enable = true;
    };

    shellAliases = {
      cat = "bat";
      c = "clear";
      lg = "lazygit --use-config-file ~/dotfiles/lazygit/theme.yml";
      ld = "lazydocker";
      ta = "tmux attach -t";
      tc = "clear; tmux clear-history; clear";
      td = "tmux detach";
      tk = "tmux kill-session -t ";
      tl = "tmux list-sessions";
      tn = "tmux new-session -s ";
      dark = "~/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh dark";
      light = "~/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh light";
      v = "nvim";
      y = "yazi";
    };

    history = {
      save = 5000;
      size = 5000;
      path = "$HOME/.zsh_history";
      share = true;
      append = true;
      ignoreSpace = true;
      ignoreDups = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true; # This replaces saveNoDups
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "copyfile"
        "docker"
        "docker-compose"
        "direnv"
        "eza"
        "fzf"
        "golang"
        "history"
        "terraform"
        "zoxide"
        "zsh-interactive-cd"
      ];

      extraConfig = ''

        # History completion
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
      '';
    };

    initExtra = ''
      # Export the PATH for Nix integration
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      # Rust binary location
      export PATH="$HOME/.cargo/bin:$PATH"

      # Colors for eza
      export LS_COLORS="$(vivid generate catppuccin-macchiato)"
    '';
  };
}
