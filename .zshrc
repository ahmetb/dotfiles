# enable profiling
# zmodload zsh/zprof

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
setopt PUSHD_SILENT             # Do not print directory stack after pushd/popd
setopt AUTO_CD                  # Use cd by just typing directory name

# Completion settings
setopt ALWAYS_TO_END          # Move cursor to end of word if completed in-word
setopt AUTO_MENU              # Show completion menu on successive tab press
setopt COMPLETE_IN_WORD       # Complete from both ends of a word
setopt PATH_DIRS              # Perform path search even on command names with slashes
setopt AUTO_PARAM_SLASH       # If completed parameter is a directory, add a trailing slash.

# Colorize completion menus
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select

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

autoload -U select-word-style
select-word-style bash

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

# Don't sort CLI options
zstyle ':completion:complete:*:options' sort false

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
# [[ ! -d ${ZSH_CACHE_DIR}/completions ]] && mkdir -p ${ZSH_CACHE_DIR}/completions
# fpath=(
#     "$HOMEBREW_PREFIX/share/zsh/site-functions"
#     "${ZSH_CACHE_DIR}/completions"
#     $fpath
# )

autoload -Uz compinit
compinit

zinit wait lucid light-mode for \
    hlissner/zsh-autopair \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
        OMZP::colored-man-pages \
    atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' zsh-users/zsh-completions

# Essential plugins
zinit wait lucid light-mode for \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions

# Load plugins with zinit
zinit ice wait lucid
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZL::directories.zsh

zinit ice wait lucid
zinit snippet OMZL::completion.zsh

zinit ice wait lucid
zinit snippet OMZL::git.zsh

zinit ice wait lucid
zinit snippet OMZP::colored-man-pages

# Load vi mode synchronously because we need it for key bindings
zinit load jeffreytse/zsh-vi-mode

# z(1) support
zinit ice wait lucid
zinit light agkozak/zsh-z

zinit ice wait lucid
zinit snippet OMZP::kubectl

# url quoting on paste
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

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
