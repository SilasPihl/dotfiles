{ config
, pkgs
, user
, lib
, ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Bat
      cat = "bat";
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
      # lg is provided by programs.lazygit with directory change support
      ld = "lazydocker";

      # Ghostty
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";

      # Git
      gl = "git pull --rebase";
      ga = "git add";
      gaa = "git add .";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gst = "git status";
      gco = "git checkout";
      gc = "git commit --signoff -S -n -m \"$(claude -p \"Look at the staged git changes and create a conventional commit message (e.g., 'feat: Add new feature', 'fix: Resolve bug', 'refactor: Refactor old code', 'docs: Update documentation'). Only respond with the complete message, including the type and scope if applicable, and no affirmation.\")\"";
      gd = "git diff";
      gr = "git restore";
      grs = "git restore --staged";
      grrevert = "git restore --source=HEAD -- .";

      # Git worktree workflow helpers
      gwl = "git worktree list";
      gwt = "git worktree";
      gwcd = "cd $(git worktree list | fzf | awk '{print $1}')";  # Interactive worktree directory change

      # Tmux
      tl = "tmux list-sessions";
      ta = "tmux attach-session -t";
      tk = "tmux kill-session -t";
      td = "tmux detach";
      tn = "tmux new-session -s";

      # Eza
      ls = "eza";
      lt = "eza -lTag";
      lt1 = "eza -lTag --level=1";
      lt2 = "eza -lTag --level=2";
      lt3 = "eza -lTag --level=3";

      # Other
      cd = "z";
      v = "nvim";
      t = "task";
      c = "cursor .";
      cl = "clear";
      cc = "claude";
      ccd = "claude --dangerously-skip-permissions";
      down = "task compose:down";
      up = "task compose:up";
      tload = "task home-manager:switch";
      tup = "task tilt:up";
      tup0 = "task tilt:0";
      tup1 = "task tilt:1";
      tup2 = "task tilt:2";
      tup3 = "task tilt:3";

      # Navigation shortcuts
      cdf = "cd src/frontend && npm i && npm run build";

      # Zoxide
      cda = "ls -d */ | xargs -I {} zoxide add {}";
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
        "copyfile"
        "colored-man-pages"
        "docker"
        "docker-compose"
        "direnv"
        "eza"
        "fzf"
        "golang"
        "gh"
        # "git"
        # "git-extras"
        "gitfast"
        "history"
        "podman"
        "terraform"
        "zoxide"
        "zsh-interactive-cd"
      ];

      extraConfig = ''
        # Disable automatic title setting to preserve manual tmux pane titles
        DISABLE_AUTO_TITLE="true"

        # History completion
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
      '';
    };

    initContent = ''
      # Save builtin cd as cdd before oh-my-zsh aliases take effect
      alias cdd='builtin cd'

      # Unalias lg if it was set by oh-my-zsh plugins (to allow lazygit function)
      unalias lg 2>/dev/null || true

      # Export the PATH for Nix integration
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      # Rust binary location
      export PATH="$HOME/.cargo/bin:$PATH"

      # Homebrew shell environment (added for nix-darwin Homebrew installs)
      export PATH=/opt/homebrew/bin:$PATH

      # Eza - Catppucin
      export LS_COLORS="$(vivid generate catppuccin-macchiato)"

      # Fzf - Catppuccin
      export FZF_DEFAULT_OPTS=" \
      --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
      --color=selected-bg:#494d64 \
      --multi"

      # I currently have an issue of "go: cannot find GOROOT directory:
      # /libexec" but I cannot find where this is set so now I am explicitly
      # unsetting it until further.
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

      function gwrm() {
        # Remove worktree by selecting from list
        local worktree=$(git worktree list | grep -v "$(git rev-parse --show-toplevel)" | fzf | awk '{print $1}')
        if [ -n "$worktree" ]; then
          git worktree remove "$worktree"
        fi
      }

      function gwadd() {
        # Create new worktree next to repo root and cd into it
        local branch_name="$1"
        local dest_path="$2"

        if [ -z "$branch_name" ]; then
          echo "Usage: gwadd <branch-name> [path]"
          return 1
        fi

        if ! command -v git >/dev/null 2>&1; then
          echo "gwadd: git is not in PATH" >&2
          return 1
        fi

        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "gwadd: not inside a git repository" >&2
          return 1
        fi

        local repo_root repo_name parent_dir
        repo_root="$(git rev-parse --show-toplevel)" || return 1
        repo_name="''${repo_root:t}"
        parent_dir="''${repo_root:h}"

        if [ -z "$dest_path" ]; then
          dest_path="$parent_dir/$repo_name-$branch_name"
        fi

        if git show-ref --verify --quiet "refs/heads/$branch_name"; then
          git worktree add "$dest_path" "$branch_name" || return $?
        else
          git worktree add -b "$branch_name" "$dest_path" || return $?
        fi

        builtin cd -- "$dest_path"
      }

      function grsoft() {
        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "Not a git repository." >&2
          return 1
        fi

        local target="$1"
        if [ -z "$target" ]; then
          git reset --soft $(git merge-base HEAD origin/main)
          return
        fi

        if [[ "$target" =~ ^[0-9]+$ ]]; then
          git reset --soft "HEAD~$target"
        else
          echo "Usage: grsoft [number]" >&2
          return 1
        fi
      }

      function grremote() {
        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "Not a git repository." >&2
          return 1
        fi

        local reset_type="--soft"
        if [[ "$1" == "-f" ]]; then
          reset_type="--hard"
        fi

        git reset "$reset_type" @{u}
      }

      function gitc() {
        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "Not a git repository." >&2
          return 1
        fi

        local message
        if [ "$#" -eq 0 ]; then
          message="Quick commit"
        else
          message="$*"
        fi

        git commit --signoff -S -n -m "$message"
      }

      function dev_with_retry() {
        # Check if another nix develop is running
        local other_nix_pids=$(pgrep -f "nix develop" | grep -v "^$$\$")

        if [ -n "$other_nix_pids" ]; then
          echo "Waiting for other nix develop processes to finish..." >&2

          # Wait up to 120 seconds for other nix processes to finish
          local max_wait=120
          local waited=0

          while [ $waited -lt $max_wait ]; do
            other_nix_pids=$(pgrep -f "nix develop" | grep -v "^$$\$")
            if [ -z "$other_nix_pids" ]; then
              break
            fi
            sleep 1
            waited=$((waited + 1))
          done

          if [ $waited -ge $max_wait ]; then
            echo "Warning: Other nix develop processes still running after ''${max_wait}s, proceeding anyway..." >&2
          fi
        fi

        # Now run nix develop normally
        nix develop "$@"
      }

      # Taskfile auto-completion
      eval "$(task --completion zsh)"

      if [ -n "$NIX_FLAKE_NAME" ]; then
        export RPROMPT="%F{green}($NIX_FLAKE_NAME)%f";
      fi

      # Ensure Python virtual environment takes precedence
      if [ -n "$VIRTUAL_ENV" ]; then
        export PATH="$VIRTUAL_ENV/bin:$PATH"
      fi

      export GPG_TTY=$(tty)

    '';
  };
}