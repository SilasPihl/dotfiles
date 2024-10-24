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
      cd = "z";
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

      # Eza - Catppucin
      export LS_COLORS="$(vivid generate catppuccin-macchiato)"

      # Fzf - Catppuccin
      export FZF_DEFAULT_OPTS=" \
      --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
      --color=selected-bg:#494d64 \
      --multi"
    '';
  };
}
