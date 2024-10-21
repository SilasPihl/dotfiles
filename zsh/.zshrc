# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
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

# Git aliases
source ~/.zshrc-git

# Aliases
bindkey -r '^L'

# For prevewing files directly in terminal
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

alias c="clear"
alias cat="bat"
alias 'cd'="z"
alias ls="eza --color=auto --long --no-filesize --icons=always --no-time --almost-all"
alias python="python3"
alias gcl="gitlab-ci-local"
alias lg="lazygit"
alias ld="lazydocker"
alias ta="tmux attach -t"
alias tc="clear; tmux clear-history; clear"
alias td="tmux detach"
alias tk="tmux kill-session -t "
alias stl="mux list-sessions"
alias tn="tmux new-session -s "
alias tf="terraform"
alias dark="~/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh dark"
alias light="~/dotfiles/kitty/.config/kitty/toggle_kitty_theme.sh light"
alias v="nvim"
alias y="yazi"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# Powerlevel10k
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

# Nix
if [ -n "$NIX_FLAKE_NAME" ]; then
  export RPROMPT="%F{green}($NIX_FLAKE_NAME)%f";
fi

eval "$(direnv hook zsh)"
