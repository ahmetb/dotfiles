SELF_DIR="$HOME/workspace/dotfiles"

# Homebrew install path customization
if ! command -v brew &>/dev/null; then
    echo >&2 "Skipping homebrew initialization in shell."
else
    # brew shellenv exports HOMEBREW_PREFIX, PATH etc.
    eval $(brew shellenv)
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_INSECURE_REDIRECT=1
fi

# Add zsh completion scripts installed via Homebrew
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

# Load Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing Zinit...%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Load zinit annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


# Load plugins with zinit
zinit ice wait lucid
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZP::colored-man-pages

# Load vi mode synchronously because we need it for key bindings
zinit load jeffreytse/zsh-vi-mode

# Syntax highlighting and autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit load zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit load zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit snippet OMZP::z

zinit ice wait lucid
zinit snippet OMZP::kubectl

if [[ -f "${SELF_DIR}/zsh_functions.inc" ]]; then
  zinit ice wait lucid
  zinit snippet "${SELF_DIR}/zsh_functions.inc"
fi

# Load custom aliases
if [[ -f "${SELF_DIR}/zsh_aliases.inc" ]]; then
    zinit ice wait lucid
    zinit snippet "${SELF_DIR}/zsh_aliases.inc"
else
    echo >&2 "WARNING: can't load shell aliases"
fi

# Initialize completion system
# use caching for some speedup https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206
autoload -Uz compinit
compinit
zi cdreplay -q # <- execute compdefs provided by rest of plugins
# zi cdlist # look at gathered compdefs

zinit snippet OMZP::direnv

# Key bindings and FZF setup
zvm_after_init_commands+=( #"bindkey '^[[A' up-line-or-beginning-search"
    # "bindkey '^[[B' down-line-or-beginning-search"
    'eval "$(fzf --zsh)"'
    "autoload -U edit-command-line"
    "zle -N edit-command-line"
    "bindkey '^X' edit-command-line"
)

# oh-my-posh-prompt
export ITERM2_SQUELCH_MARK=1
eval "$(oh-my-posh init zsh --config ~/.oh-my-posh.omp.yaml)"

# User configuration
export EDITOR="vim"
export VISUAL="$VISUAL"

# use system paths (e.g. /etc/paths.d/)
[[ -f "/usr/libexec/path_helper" ]] && eval "$(/usr/libexec/path_helper -s)"

# go tools
PATH="$HOME/gotools/bin:$PATH"

# git: use system ssh for git, otherwise UseKeychain option doesn't work
# export GIT_SSH=/usr/bin/ssh

# python: replace system python
PATH="$HOMEBREW_PREFIX/opt/python/libexec/bin:$PATH"

# iTerm2 integration
# if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
#   source "${HOME}/.iterm2_shell_integration.zsh"
# else
#   log "WARNING: skipping loading iterm2 shell integration"
# fi

# kubectl aliases
[ -f ~/.kubectl_aliases ] && source <(cat ~/.kubectl_aliases | sed -r 's/(kubectl.*) --watch/watch \1/g')

# Add various paths
PATH="${SELF_DIR}/bin:${PATH}"
PATH="${KREW_ROOT:-$HOME/.krew}/bin:${PATH}"
PATH="${HOME}/go/bin:${PATH}"
PATH="${HOME}/.cargo/bin:${PATH}"

# bat pager for scrolling support
export BAT_PAGER="less -RF"

# Work priority
PATH=/usr/local/\li\nk\ed\in/bin:${PATH}

# Prioritize homebrew bins
PATH="$HOMEBREW_PREFIX/bin:$PATH"

# kubectl completion (disabled in favor of OMZP::kubectl)
# if command -v kubectl > /dev/null; then
#     kcomp="$HOME/.kube/.zsh_completion"
#     if [ ! -f "$kcomp" ] ||  [ "$(( $(date +"%s") - $(gstat -c "%Y" "$kcomp") ))" -gt "172800" ]; then
#         mkdir -p "$(dirname "$kcomp")"
#         kubectl completion zsh > "$kcomp"
#         log "refreshing kubectl zsh completion at $kcomp ($(which kubectl))"
#     fi
#     . "$kcomp"
# fi

# kubecolor
if command -v kubecolor > /dev/null; then
    alias kubectl=kubecolor
    compdef kubecolor=kubectl
fi

# Export final PATH and other environment variables
export PATH
