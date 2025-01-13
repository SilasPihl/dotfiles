{
  config,
  pkgs,
  user,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Bat
      pbat = "prettybat";
      bgrep = "batgrep";
      grep = "rg";
      bman = "batman";
      bwatch = "batwatch";
      bpipe = "batpipe";

      # Nix
      dev = "nix develop";
      cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";

      # Remove this annoying fd alias coming from maybe common-aliases plugin or hm fd module
      # fd: aliased to fd '--hidden' '--no-ignore' '--no-absolute-path'
      # https://github.com/ohmyzsh/ohmyzsh/issues/9414#issuecomment-734947141
      fd = lib.mkForce "fd";

      # Lazy
      lg = "lazygit";
      ld = "lazydocker";

      # Ghostty
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";

      # Tmux
      tl = "tmux list-sessions";
      ta = "tmux attach-session -t";
      tk = "tmux kill-session -t";
      td = "tmux detach";
      tn = "tmux new-session -s";

      # Eza
      lt = "eza -lTag";
      lt1 = "eza -lTag --level=1";
      lt2 = "eza -lTag --level=2";
      lt3 = "eza -lTag --level=3";
      # Just for quicker iterations on home-manager. Will probably be removed once setup stabilizes
      hmac = "nix run home-manager/master -- switch --flake .#mac";

      # Other
      cd = "z";
      v = "nvim";
      t = "task";
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
        "colored-man-pages"
        "docker"
        "docker-compose"
        "direnv"
        "fancy-ctrl-z"
        # "eza"
        "fzf"
        "golang"
        "git"
        "git-extras"
        "gitfast"
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

      # command -v eza >/dev/null 2>&1 && {
      #   alias ls='eza'
      # }
      #
      # command -v bat >/dev/null 2>&1 && {
      #   alias cat='bat'
      # }

      # Fzf - Catppuccin
      export FZF_DEFAULT_OPTS=" \
      --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
      --color=selected-bg:#494d64 \
      --multi"

      # I currently have an issue of "go: cannot find GOROOT directory:
      # /libexec" but I cannot find where this is set so now I am explicitly
      # unsetting in until further.
      unset GOROOT

      if [ -e ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then
        source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh;
      fi

      command -v fzf >/dev/null 2>&1 && {
        source <(fzf --zsh)
      }

      # Yazi
      function y() {
       local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
       yazi "$@" --cwd-file="$tmp"
       if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      	 builtin cd -- "$cwd"
       fi
       rm -f -- "$tmp"
      }

      eval "$(task --completion zsh)"

      if [ -n "$NIX_FLAKE_NAME" ]; then
        export RPROMPT="%F{green}($NIX_FLAKE_NAME)%f";
      fi

    '';
  };
}
