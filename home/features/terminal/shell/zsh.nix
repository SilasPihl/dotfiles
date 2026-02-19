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
      gc = "git commit --signoff -S -n -m \"$(claude -p \"Look at the staged git changes and create a conventional commit message (e.g., 'feat: Add new feature', 'fix: Resolve bug', 'refactor: Refactor old code', 'docs: Update documentation'). Only respond with the complete message, including the type and scope if applicable, and no affirmation. Do not wrap in backticks or code blocks.\")\"";
      gd = "git diff";
      gr = "git restore";
      grs = "git restore --staged";
      grrevert = "git restore --source=HEAD -- .";

      # Git worktree workflow helpers
      gwl = "git worktree list";
      gw = "git worktree";
      gwcd_old = "cd $(git worktree list | fzf | awk '{print $1}')";  # Interactive worktree directory change

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
      # c is defined as a function in initContent for Hammerspoon integration
      cl = "clear";
      cc = "claude";
      ccd = "claude --dangerously-skip-permissions";
      down = "docker compose rm -sf db dbadmin centrifugo flagd nats-1 nats-2 nats-3 redisinsight && docker volume ls -q --filter name=lixcloud_ | /usr/bin/grep -vE 'redis|valkey' | xargs docker volume rm -f 2>/dev/null; true";
      downf = "task compose:down";
      up = "task compose:up";
      tload = "task home-manager:switch && source ~/.zshrc";
      sz = "source ~/.zshrc";
      tup = "task tilt:up";
      tup0 = "task tilt:0";
      tup1 = "task tilt:1";
      tup2 = "task tilt:2";
      tup3 = "task tilt:3";

      # Navigation shortcuts
      cdf = "cd src/frontend && rm -rf node_modules && npm i && npm run build";

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

        # Prevent programs from changing the pane title
        # Override precmd and preexec to do nothing with titles
        precmd_functions=()
        preexec_functions=()

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

      # Cursor: open in current dir and position on DELL (right 70%)
      function c() {
        (cursor "''${1:-.}" &>/dev/null &)
        open -g "hammerspoon://launchCursor"
      }

      # Lazygit: zoom pane to full window, run lazygit, then restore
      function lg() {
        if [[ -n "$TMUX" ]]; then
          # Zoom pane to fill window, run lazygit, then unzoom
          tmux resize-pane -Z
          lazygit "$@"
          tmux resize-pane -Z
        else
          # Fallback with directory change support
          export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
          lazygit "$@"
          if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
          fi
        fi
      }

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
        # Remove worktree and its branch by selecting from list
        local selection=$(git worktree list | grep -v "$(git rev-parse --show-toplevel)" | fzf)
        if [ -n "$selection" ]; then
          local worktree=$(echo "$selection" | awk '{print $1}')
          local branch=$(echo "$selection" | awk '{print $3}' | sed 's/\[//' | sed 's/\]//')

          git worktree remove "$worktree" || return 1

          if [ -n "$branch" ]; then
            git branch -D "$branch"
          fi
        fi
      }

      function gwadd() {
        # Create new worktree up one folder and cd into it
        # Usage: gwadd <worktree-name> [branch-name]
        #   gwadd feature              -> creates silas/feature branch
        #   gwadd feature sbal/feature -> checks out existing sbal/feature branch
        local worktree_name="$1"
        local branch_arg="$2"

        if [ -z "$worktree_name" ]; then
          echo "Usage: gwadd <worktree-name> [branch-name]"
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

        local branch_name dest_path
        dest_path="../wt-$worktree_name"

        if [ -n "$branch_arg" ]; then
          # Explicit branch provided - check it out
          git worktree add "$dest_path" "$branch_arg" || return $?
        else
          # No branch provided - use silas/ prefix convention
          branch_name="silas/$worktree_name"
          if git show-ref --verify --quiet "refs/heads/$branch_name"; then
            git worktree add "$dest_path" "$branch_name" || return $?
          else
            git worktree add -b "$branch_name" "$dest_path" || return $?
          fi
        fi

        builtin cd -- "$dest_path"
      }

      function gwswitch() {
        if ! command -v git &>/dev/null; then
          echo "error: git is required but not installed" >&2
          return 1
        fi
        if ! command -v fzf &>/dev/null; then
          echo "error: fzf is required but not installed" >&2
          return 1
        fi

        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "error: not inside a git repository" >&2
          return 1
        fi

        local repo_root
        repo_root=$(git rev-parse --show-toplevel) || return 1

        git fetch origin || return 1

        local branch
        branch=$(git branch -r | grep -v HEAD | sed 's|origin/||' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | fzf --print-query --prompt="Choose remote branch: " --height=40% --reverse | tail -1)
        if [ -z "''${branch}" ]; then
          echo "operation cancelled"
          return 0
        fi

        # Extract the part after silas/ if it exists, otherwise use full branch name
        local worktree_name="''${branch}"
        local branch_path="''${repo_root}/../wt-''${worktree_name}"

        if [ -d "''${branch_path}" ]; then
          echo "navigating to existing worktree ..."
          cd "''${branch_path}/" || return 1
          git status || return 1
          return 0
        fi

        if git show-ref --verify --quiet "refs/remotes/origin/''${branch}"; then
          # remote branch exists
          git worktree add "''${branch_path}" "''${branch}" || return 1
          cd "''${branch_path}/" || return 1
        else
          # no remote branch - check local or create with silas/ prefix
          local full_branch="silas/''${worktree_name}"
          if git show-ref --verify --quiet "refs/heads/''${full_branch}"; then
            # local branch exists with silas/ prefix
            git worktree add "''${branch_path}" "''${full_branch}" || return 1
          else
            # no local branch -> create one with silas/ prefix
            git worktree add -b "''${full_branch}" "''${branch_path}" || return 1
          fi
          cd "''${branch_path}/" || return 1
          git push -u origin "''${full_branch}" || return 1
        fi
        git status
      }

      function gwcd() {
        local selection worktree
        selection=$(git worktree list | grep -v '(bare)' | fzf --height=40% --reverse --prompt="Select worktree: ")
        if [[ -n "$selection" ]]; then
          worktree=$(echo "$selection" | awk '{print $1}')
          cd "$worktree" || return 1
        fi
      }

      # Fork workflow: experiment in a new worktree, review, apply back
      function gwfork() {
        local name="$1"
        if [ -z "$name" ]; then
          echo "Usage: gwfork <name>"
          return 1
        fi

        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "gwfork: not a git repo" >&2
          return 1
        fi

        local current_branch=$(git branch --show-current)
        local current_path=$(git rev-parse --show-toplevel)
        local branch_name="silas/$name"
        local dest_path="../wt-$name"

        if git show-ref --verify --quiet "refs/heads/$branch_name"; then
          echo "gwfork: branch $branch_name already exists" >&2
          return 1
        fi

        git worktree add -b "$branch_name" "$dest_path" || return $?

        # Store parent info in shared git config
        git config "gwfork.$branch_name.parent" "$current_branch"
        git config "gwfork.$branch_name.parentPath" "$current_path"

        local abs_path=$(builtin cd "$dest_path" && pwd)
        if [[ -n "$TMUX" ]]; then
          tmux new-window -n "fork:$name" -c "$abs_path"
        else
          builtin cd -- "$abs_path"
        fi

        echo "Forked $current_branch -> $branch_name"
      }

      function gwdiff() {
        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "gwdiff: not a git repo" >&2
          return 1
        fi

        local current_branch=$(git branch --show-current)
        local parent=$(git config "gwfork.$current_branch.parent")

        if [ -z "$parent" ]; then
          echo "gwdiff: not a fork (no parent found for $current_branch)" >&2
          return 1
        fi

        if [[ -n "$TMUX" ]]; then
          tmux split-window -h "git diff $parent..HEAD"
        else
          git diff "$parent..HEAD"
        fi
      }

      function gwback() {
        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "gwback: not a git repo" >&2
          return 1
        fi

        local current_branch=$(git branch --show-current)
        local parent=$(git config "gwfork.$current_branch.parent")
        local parent_path=$(git config "gwfork.$current_branch.parentPath")

        if [ -z "$parent" ] || [ -z "$parent_path" ]; then
          echo "gwback: not a fork (no parent found for $current_branch)" >&2
          return 1
        fi

        if [ ! -d "$parent_path" ]; then
          echo "gwback: parent worktree not found at $parent_path" >&2
          return 1
        fi

        # Warn about uncommitted changes
        if ! git diff --quiet || ! git diff --cached --quiet; then
          echo "Warning: uncommitted changes won't be included"
          echo ""
        fi

        local changed_files=$(git diff --name-only "$parent..HEAD")
        local commit_count=$(git rev-list --count "$parent..HEAD")

        if [ -z "$changed_files" ] && [ "$commit_count" -eq 0 ]; then
          echo "No changes vs $parent."
          return 0
        fi

        echo "Changes vs $parent ($commit_count commits):"
        echo "$changed_files" | head -20
        local total=$(echo "$changed_files" | wc -l | tr -d ' ')
        [ "$total" -gt 20 ] && echo "... and $((total - 20)) more"
        echo ""

        echo "Apply to $parent_path:"
        echo "  1) All files (patch)"
        echo "  2) Pick files (fzf)"
        echo "  3) Pick commits (cherry-pick)"
        echo "  4) Cancel"
        read -r "choice?> "

        case "$choice" in
          1)
            git diff "$parent..HEAD" | (cd "$parent_path" && git apply)
            if [ $? -eq 0 ]; then
              echo "Applied all changes."
            else
              echo "Some changes failed to apply." >&2
              return 1
            fi
            ;;
          2)
            local selected=$(echo "$changed_files" | fzf --multi --prompt="Pick files: " --height=40% --reverse)
            if [ -n "$selected" ]; then
              echo "$selected" | while read -r file; do
                git diff "$parent..HEAD" -- "$file" | (cd "$parent_path" && git apply)
              done
              echo "Applied selected files."
            else
              echo "No files selected."
              return 0
            fi
            ;;
          3)
            local commits=$(git log --oneline --reverse "$parent..HEAD" | fzf --multi --prompt="Pick commits: " --height=40% --reverse | awk '{print $1}')
            if [ -n "$commits" ]; then
              (cd "$parent_path" && echo "$commits" | while read -r hash; do
                git cherry-pick --no-commit "$hash" || { echo "Cherry-pick $hash failed" >&2; return 1; }
              done)
              echo "Cherry-picked to $parent_path (staged, not committed)."
            else
              echo "No commits selected."
              return 0
            fi
            ;;
          *)
            echo "Cancelled."
            return 0
            ;;
        esac

        echo ""
        read -r "cleanup?Remove fork $current_branch? [y/N] "
        if [[ "$cleanup" =~ ^[Yy]$ ]]; then
          local fork_path=$(git rev-parse --show-toplevel)
          builtin cd "$parent_path"
          git worktree remove "$fork_path" 2>/dev/null
          git branch -D "$current_branch" 2>/dev/null
          git config --remove-section "gwfork.$current_branch" 2>/dev/null
          echo "Cleaned up fork."
        else
          builtin cd "$parent_path"
          echo "Switched to parent worktree."
        fi
      }

      function gci() {
        # Interactive checkout: shows PRs first, then recent branches
        git fetch origin || return 1

        # Build map of branch -> PR info
        local -A prs
        while IFS=$'\t' read -r num title branch; do
          prs[$branch]="#$num $title"
        done < <(gh pr list --state open --json number,title,headRefName --jq '.[] | [.number, .title, .headRefName] | @tsv')

        # Collect branches sorted by date, PRs first
        local pr_lines="" other_lines=""
        while read -r branch; do
          [[ "$branch" == "origin/HEAD" ]] && continue
          local short="''${branch#origin/}"
          if [[ -n "''${prs[$short]}" ]]; then
            pr_lines+="[PR] ''${prs[$short]} [$short]"$'\n'
          else
            other_lines+="$short"$'\n'
          fi
        done < <(git branch -r --sort=-committerdate --format='%(refname:short)')

        local selection
        selection=$(printf "%s%s" "$pr_lines" "$other_lines" | grep -v '^$' | fzf --prompt="Checkout: " --height=40% --reverse)

        if [ -n "$selection" ]; then
          if [[ "$selection" == "[PR]"* ]]; then
            local pr_number=$(echo "$selection" | grep -o '#[0-9]*' | tr -d '#')
            gh pr checkout "$pr_number"
          else
            git checkout "$selection"
          fi
        fi
      }

      function __gr_base_ref() {
        local parent
        parent=$(git town config get-parent 2>/dev/null)
        if [ -n "$parent" ]; then
          echo "origin/$parent"
        else
          echo "origin/main"
        fi
      }

      function grsoft() {
        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "Not a git repository." >&2
          return 1
        fi

        local target="$1"
        if [ -z "$target" ]; then
          git reset --soft $(git merge-base HEAD $(__gr_base_ref))
          return
        fi

        if [[ "$target" == "-m" ]]; then
          git reset --soft $(git merge-base HEAD origin/main)
          return
        fi

        if [[ "$target" =~ ^[0-9]+$ ]]; then
          git reset --soft "HEAD~$target"
        else
          echo "Usage: grsoft [-m | number]" >&2
          return 1
        fi
      }

      function grhard() {
        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo "Not a git repository." >&2
          return 1
        fi

        local target="$1"
        if [ -z "$target" ]; then
          git reset --hard $(git merge-base HEAD $(__gr_base_ref))
          return
        fi

        if [[ "$target" == "-m" ]]; then
          git reset --hard $(git merge-base HEAD origin/main)
          return
        fi

        if [[ "$target" =~ ^[0-9]+$ ]]; then
          git reset --hard "HEAD~$target"
        else
          echo "Usage: grhard [-m | number]" >&2
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

      # Put command input on new line for small terminal windows
      # Move git dirty indicator (×) to second line with prompt
      ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%})"
      ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%})"

      function _prompt_symbol() {
        if git rev-parse --is-inside-work-tree &>/dev/null; then
          if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            echo "%{$fg[yellow]%}✗%{$reset_color%} "
          else
            echo "%{$fg[green]%}❯%{$reset_color%} "
          fi
        else
          echo "%{$fg[green]%}❯%{$reset_color%} "
        fi
      }

      PROMPT=$PROMPT$'\n''$(_prompt_symbol)'

      # Ensure Python virtual environment takes precedence
      if [ -n "$VIRTUAL_ENV" ]; then
        export PATH="$VIRTUAL_ENV/bin:$PATH"
      fi

      export GPG_TTY=$(tty)

    '';
  };
}