# enable profiling
zmodload zsh/zprof

SELF_DIR="$HOME/workspace/dotfiles"

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY          # Write timestamps to history
setopt SHARE_HISTORY            # Share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS         # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS     # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS        # Do not display a line previously found
setopt HIST_SAVE_NO_DUPS        # Don't write duplicate entries
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks before recording entry
setopt HIST_IGNORE_SPACE


# Directory navigation
setopt AUTO_PUSHD               # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS        # Do not store duplicates in the stack
setopt PUSHD_SILENT            # Do not print directory stack after pushd/popd
setopt AUTO_CD                  # Use cd by just typing directory name

# Completion settings
setopt ALWAYS_TO_END           # Move cursor to end of word if completed in-word
setopt AUTO_MENU              # Show completion menu on successive tab press
setopt COMPLETE_IN_WORD       # Complete from both ends of a word
setopt PATH_DIRS              # Perform path search even on command names with slashes

# Colorize completion menus (disabled in favor of fzf-tab)
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Job control
setopt LONG_LIST_JOBS         # List jobs in long format
setopt AUTO_RESUME           # Attempt to resume existing job before creating a new process
setopt NOTIFY               # Report status of background jobs immediately

# Input/Output
setopt CORRECT              # Try to correct the spelling of commands
setopt INTERACTIVE_COMMENTS  # Allow comments in interactive shells
setopt RC_QUOTES           # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'

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

# LS_COLORS
zinit light trapd00r/LS_COLORS
zinit pack for ls_colors
zinit lucid reset \
 atclone"[[ -z ${commands[dircolors]} ]] && local P=g
    \${P}sed -i '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
    \${P}dircolors -b LS_COLORS > clrs.zsh" \
 atpull'%atclone' pick"clrs.zsh" nocompile'!' for \
    trapd00r/LS_COLORS

# Case-insensitive completion matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Format completion messages
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BNo matches for: %d%b'

# Group matches and describe groups
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

# Use caching to make completion faster
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

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
[[ ! -d ${ZSH_CACHE_DIR}/completions ]] && mkdir -p ${ZSH_CACHE_DIR}/completions
fpath=(
    "$HOMEBREW_PREFIX/share/zsh-completions"
    "$HOMEBREW_PREFIX/share/zsh/site-functions"
    "${ZSH_CACHE_DIR}/completions"
    $fpath
)

# Core ZSH configuration
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Essential plugins
zinit wait lucid light-mode for \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions

# Load plugins with zinit
zinit ice wait lucid
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZL::directories.zsh

zinit ice wait lucid
zinit snippet OMZP::colored-man-pages

# Load vi mode synchronously because we need it for key bindings
zinit load jeffreytse/zsh-vi-mode

# Autosuggestions
# zinit ice wait lucid
# zinit load zsh-users/zsh-autosuggestions

# z(1) support
zinit ice wait lucid
zinit light agkozak/zsh-z

zinit ice wait lucid
zinit snippet OMZP::kubectl

# Enhanced cd command
zinit ice wait lucid
zinit light b4b4r07/enhancd


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

# direnv hook
zinit snippet OMZP::direnv

# Key bindings and FZF setup
zvm_after_init_commands+=(
    "bindkey '^[[A' up-line-or-beginning-search"
    "bindkey '^[[B' down-line-or-beginning-search"
    "bindkey '^X' edit-command-line"
)

# enable prefix searches in up/down cmds (binding in zvm_after_init_commands)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# enable ctrl+X to edit command line
autoload -U edit-command-line
zle -N edit-command-line

# enable fzf integration (ctrl+R for history search)
zinit ice lucid wait
zinit snippet OMZP::fzf

# install fzf-tab completion
zinit ice wait lucid
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:*' fzf-flags '--height=40%'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'

# oh-my-posh-prompt
export ITERM2_SQUELCH_MARK=1
eval "$(oh-my-posh init zsh --config ~/.oh-my-posh.omp.yaml)"

# use system paths (e.g. /etc/paths.d/)
# [[ -f "/usr/libexec/path_helper" ]] && eval "$(/usr/libexec/path_helper -s)"

# go tools
PATH="$HOME/gotools/bin:$PATH"

# overwrite macOS utils with coreutils
PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

# git: use system ssh for git, otherwise UseKeychain option doesn't work
# export GIT_SSH=/usr/bin/ssh

# python: replace system python
PATH="$HOMEBREW_PREFIX/opt/python/libexec/bin:$PATH"

# kubectl aliases
[ -f ~/.kubectl_aliases ] && source <(cat ~/.kubectl_aliases | sed -r 's/(kubectl.*) --watch/watch \1/g')

# Add various paths
PATH="${SELF_DIR}/bin:${PATH}"
PATH="${KREW_ROOT:-$HOME/.krew}/bin:${PATH}"
PATH="${HOME}/go/bin:${PATH}"
PATH="${HOME}/.cargo/bin:${PATH}"

# User configuration
export EDITOR="vim"
export VISUAL="$VISUAL"
export BAT_PAGER="less -RF" # bat pager for scrolling support

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

# kubecolor to override kubectl
if command -v kubecolor > /dev/null; then
    alias kubectl=kubecolor
    compdef kubecolor=kubectl
fi


# Export final PATH and other environment variables
export PATH
