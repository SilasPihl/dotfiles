{ config, pkgs, user, ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestion = { enable = true; };

    shellAliases = {
      cat = "prettybat";
      bat = "prettybat";
      grep = "batgrep";
      man = "batman";
      watch = "batwatch";
      pipe = "batpipe";
      c = "clear";
      cd = "z";
      dev = "nix develop";
      lg =
        "lazygit --use-config-file /Users/${user}/dotfiles/themes/lazygit/theme.yml";
      ld = "lazydocker";
      lt = "eza -lTag";
      lt1 = "eza -lTag --level=1";
      lt2 = "eza -lTag --level=2";
      lt3 = "eza -lTag --level=3";
      ta = "tmux attach -t";
      tc = "clear; tmux clear-history; clear";
      td = "tmux detach";
      tk = "tmux kill-session -t ";
      tl = "tmux list-sessions";
      tn = "tmux new-session -s ";
      dark =
        "~/dotfiles/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh dark";
      light =
        "~/dotfiles/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh light";
      v = "nvim";
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

      # https://github.com/nix-community/nix-direnv/issues/324#issuecomment-1490085474
      # function enterNixDevelopShell {
      #     if test -f flake.nix; then nix develop . --impure; fi
      #   }
      #   chpwd_functions=(''${chpwd_functions[@]} "enterNixDevelopShell")

      # I currently have an issue of "go: cannot find GOROOT directory:
      # /libexec" but I cannot find where this is set so now I am explicitly
      # unsetting in until further.
      unset GOROOT

      EDITOR=nvim

      if [ -e ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then
        source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh;
      fi

      command -v k9s >/dev/null 2>&1 && {
        alias k9='k9s --request-timeout=10s --headless --command namespaces'
      }

      command -v kubectl >/dev/null 2>&1 && {
        alias k='kubectl'
        # shellcheck disable=SC1090
        source <(kubectl completion zsh)
        # complete -F __start_kubectl k
      }

      command -v helm >/dev/null 2>&1 && {
        alias h='helm'
        # shellcheck disable=SC1090
        source <(helm completion zsh)
        # complete -F __start_helm h
      }

      command -v flux >/dev/null 2>&1 && {
        alias f='flux'
        # shellcheck disable=SC1090
        source <(flux completion zsh)
        # complete -F __start_flux f
      }

      command -v fzf >/dev/null 2>&1 && {
        source <(fzf --zsh)
      }

      command -v talosctl >/dev/null 2>&1 && {
        source <(talosctl completion zsh)
      }

      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      if [ -n "$NIX_FLAKE_NAME" ]; then
        export RPROMPT="%F{green}($NIX_FLAKE_NAME)%f";
      fi

    '';
  };
}
