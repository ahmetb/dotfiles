SELF_DIR="$(dirname $(realpath ~/.zshrc))"

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

# ZSH settings
	export ZSH=$HOME/.oh-my-zsh
	# ZSH_THEME=af-magic
	ZSH_THEME=geoffgarside

	# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
	# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
	plugins=(git colored-man-pages zsh-completions)
	source "$ZSH/oh-my-zsh.sh"

	export UPDATE_ZSH_DAYS=14
	export DISABLE_UPDATE_PROMPT=true # accept updates by default

	# Uncomment the following line to enable command auto-correction.
	# ENABLE_CORRECTION="true"

	# Uncomment the following line to display red dots whilst waiting for completion.
	#COMPLETION_WAITING_DOTS="true"

# Load custom functions
if [[ -f "${SELF_DIR}/zsh_functions.inc" ]]; then
	source "${SELF_DIR}/zsh_functions.inc"
else
	echo >&2 "WARNING: can't load shell functions"
fi

# default prompt
PROMPT='%{$fg[green]%}%c%{$reset_color%}$(git_prompt_info) %{$fg[yellow]%}%(!.#.$)%{$reset_color%} '

# oh-my-posh-prompt
export ITERM2_SQUELCH_MARK=1
eval "$(oh-my-posh init zsh --config ~/.oh-my-posh.omp.yaml)"

# demo prompt
# PROMPT="$(tput setaf 6)\$ $(tput sgr0)"

# Key bindings
bindkey '^[x' .undo # using alt+x for recordings

# User configuration
export EDITOR="vim"
export VISUAL="$VISUAL"

# use system paths (e.g. /etc/paths.d/)
[[ -f "/usr/libexec/path_helper" ]] && eval "$(/usr/libexec/path_helper -s)"

# go tools
PATH="$PATH:$HOME/gotools/bin"

# git: use system ssh for git, otherwise UseKeychain option doesn't work
export GIT_SSH=/usr/bin/ssh

# python: replace system python
PATH="$HOMEBREW_PREFIX/opt/python/libexec/bin:$PATH"

# gcloud completion scripts
if type gcloud &>/dev/null; then
  source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi

# iTerm2 integration
if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
else
  log "WARNING: skipping loading iterm2 shell integration"
fi

# fzf completion. run $HOMEBREW_PREFIX/opt/fzf/install to create the ~/.fzf.* script
if type fzf &>/dev/null && [ -f ~/.fzf.zsh ]; then
	source ~/.fzf.zsh
else
	log "WARNING: skipping loading fzf.zsh"
fi

# z completion
if [ -f "$HOMEBREW_PREFIX/etc/profile.d/z.sh" ]; then
    . "$HOMEBREW_PREFIX/etc/profile.d/z.sh"
fi

# kubectl aliases from https://github.com/ahmetb/kubectl-alias
#    > use sed to hijack --watch to watch $@.
[ -f ~/.kubectl_aliases ] && source <(cat ~/.kubectl_aliases | sed -r 's/(kubectl.*) --watch/watch \1/g')

# kube-ps1
if [[ -f "$HOMEBREW_PREFIX/opt/kube-ps1/share/kube-ps1.sh" ]]; then
	export KUBE_PS1_PREFIX='{'
	export KUBE_PS1_SUFFIX='} '
	source "$HOMEBREW_PREFIX/opt/kube-ps1/share/kube-ps1.sh"
    # if ! is_corp_machine; then
        PROMPT="\$(kube_ps1)$PROMPT"
    # fi
fi

# add dotfiles/bin to PATH
if [[ -d "${SELF_DIR}/bin" ]]; then
	PATH="${SELF_DIR}/bin:${PATH}"
fi

# load zsh plugins installed via brew
if [[ -d "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting" ]]; then
	source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
if [[ -d "$HOMEBREW_PREFIX/share/zsh-autosuggestions" ]]; then
	# source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# krew plugins
PATH="${KREW_ROOT:-$HOME/.krew}/bin:${PATH}"

# global ~/go/bin
PATH="${HOME}/go/bin:${PATH}"
# global ~/.cargo/bin
PATH="${HOME}/.cargo/bin:${PATH}"

# direnv hook
if command -v direnv > /dev/null; then
	eval "$(direnv hook zsh)"
fi

# bat pager for scrolling support
export BAT_PAGER="less -RF"

# Load custom aliases
if [[ -f "${SELF_DIR}/zsh_aliases.inc" ]]; then
	source "${SELF_DIR}/zsh_aliases.inc"
else
	echo >&2 "WARNING: can't load shell aliases"
fi

# Load copilot CLI aliases
if [[ -f "${SELF_DIR}/github-copilot-cli-aliases.inc" ]]; then
	source "${SELF_DIR}/github-copilot-cli-aliases.inc"
else
	echo >&2 "WARNING: can't load copilot aliases"
fi

# LunarVim
export PATH=${PATH}:$HOME/.local/bin

# Work priority
PATH=/usr/local/\li\nk\ed\in/bin:${PATH}


# kubectl completion (w/ refresh cache every 48-hours)
# TODO(2022-04-19): moved here to actually reflect the version of kubectl that's going to be used
# in the shell is the one we generate completion script from.
if command -v kubectl > /dev/null; then
	kcomp="$HOME/.kube/.zsh_completion"
	if [ ! -f "$kcomp" ] ||  [ "$(( $(date +"%s") - $(gstat -c "%Y" "$kcomp") ))" -gt "172800" ]; then
		mkdir -p "$(dirname "$kcomp")"
		kubectl completion zsh > "$kcomp"
    log "refreshing kubectl zsh completion at $kcomp ($(which kubectl))"
	fi
	. "$kcomp"
fi


# finally, export the PATH
export PATH
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
