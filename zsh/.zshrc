# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Devcontainer integration
dev() {
    # Function to handle Ctrl+C (SIGINT)
    trap 'echo "Aborted by user."; return 1' SIGINT

    # Check if the .devcontainer folder exists
    if [ ! -d ".devcontainer" ]; then
        echo "No .devcontainer folder found in the current directory. Exiting."
        return 1
    fi

    # Check if the container is already running or exists
    if ! devcontainer exec --workspace-folder . /bin/true > /dev/null 2>&1; then
        echo "Starting the devcontainer..."
        devcontainer up --workspace-folder . --dotfiles-repository https://github.com/SebastianBalle/dotfiles --dotfiles-install-command ./setup
    else
        echo "Devcontainer is already running."
    fi

    # Start the shell in the container
    devcontainer exec --workspace-folder . /bin/zsh
}

# Git aliases
source ~/.zshrc-git

# Aliases
alias ls="eza --color=auto --long --no-filesize --icons=always --no-time --almost-all"
alias v='nvim'
alias c='clear'
alias cd='z'
alias python='python3'
alias tf='terraform'
alias gcl='gitlab-ci-local'
alias cat='bat'
alias y='yazi'
# alias ip="curl -qs https://ifconfig.co/json | jq -r '.ip,.city,.country,.hostname,.asn_org'"
alias dark="~/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh dark"
alias light="~/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh light"
alias lg='lazygit'
alias ld='lazydocker'
eval $(thefuck --alias)

# Tmux
alias ta='tmux attach -t'
# Creates a new session
alias tn='tmux new-session -s '
# Kill session
alias tk='tmux kill-session -t '
# Lists all ongoing sessions
alias tl='tmux list-sessions'
# Detach from session
alias td='tmux detach'
# Tmux Clear pane
alias tc='clear; tmux clear-history; clear'
bindkey -r '^L'

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Go (only if Golang is installed using Homebrew)
if [ -d "/opt/homebrew/opt/golang" ]; then
  export GOPATH="$HOME/go"
  export GOROOT="/opt/homebrew/opt/golang/libexec"
  export PATH="$PATH:$GOPATH/bin"
  export PATH="$PATH:$GOROOT/bin"
fi

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# Powerlevel10k
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

eval "$(direnv hook zsh)"
