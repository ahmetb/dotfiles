# ZSH settings
	export ZSH=/Users/$USER/.oh-my-zsh
	ZSH_THEME=af-magic
	# ZSH_THEME=geoffgarside

	# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
	# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
	plugins=(git colored-man-pages zsh-completions)
	source "$ZSH/oh-my-zsh.sh"

	# customize prompt with exitcode
	# PROMPT='[%*]%(?..%{$fg[red]%}%{$FX[bold]%}[error:%?]%{$reset_color%}) %{$fg[green]%}%c%{$reset_color%}$(git_prompt_info) %(!.#.$) '

	export UPDATE_ZSH_DAYS=14
	export DISABLE_UPDATE_PROMPT=true # accept updates by default

	# Uncomment the following line to enable command auto-correction.
	# ENABLE_CORRECTION="true"

	# Uncomment the following line to display red dots whilst waiting for completion.
	#COMPLETION_WAITING_DOTS="true"

# Load custom functions
if [[ -f "$HOME/workspace/dotfiles/zsh_functions.inc" ]]; then
	source "$HOME/workspace/dotfiles/zsh_functions.inc"
else
	echo >&2 "WARNING: can't load shell functions"
fi

# Load custom aliases
if [[ -f "$HOME/workspace/dotfiles/zsh_aliases.inc" ]]; then
	source "$HOME/workspace/dotfiles/zsh_aliases.inc"
else
	echo >&2 "WARNING: can't load shell aliases"
fi


# User configuration
export EDITOR=vim

# use system paths (e.g. /etc/paths.d/)
eval "$(/usr/libexec/path_helper -s)"

# Homebrew install path customization
	export HOMEBREW="$HOME/.homebrew"
	if [ ! -d "$HOMEBREW" ]; then
		# fallback
		echo >&2 "[~/.zshrc] WARNING: brew path $HOMEBREW not found, defaulting to /usr/local"
		export HOMEBREW=/usr/local
	fi
	PATH="$HOMEBREW/bin:$HOMEBREW/sbin:$PATH"

	# Add zsh completion scripts installed via Homebrew
	fpath=("$HOMEBREW/share/zsh-completions" $fpath)
	fpath=("$HOMEBREW/share/zsh/site-functions" $fpath)

# Reload the zsh-completions
autoload -U compinit && compinit

# PATH MANIPULATIONS
# coreutils
MANPATH="$HOMEBREW/opt/coreutils/libexec/gnuman:$MANPATH"
PATH="$HOMEBREW/opt/coreutils/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-getopt/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-indent/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/grep/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-time/libexec/gnubin:$PATH"
# PATH="$HOMEBREW/opt/ncurses/bin:$PATH" # disabled as tput doesn't work with xterm-256color
PATH="$HOMEBREW/opt/gettext/bin:$PATH"
PATH="$HOMEBREW/opt/openssl/bin:$PATH"

# go tools
PATH="$PATH:$HOME/gotools/bin"

# git: use system ssh for git, otherwise UseKeychain option doesn't work
export GIT_SSH=/usr/bin/ssh

# python: replace system python
PATH="$HOMEBREW/opt/python/libexec/bin:$PATH"

# virtualenvwrapper
if [ -f "$HOMEBREW/bin/virtualenvwrapper.sh" ]; then
	export WORKON_HOME=$HOME/workspace/.virtualenvs
	source "$HOMEBREW/bin/virtualenvwrapper.sh"
else
	log "WARNING: skipping loading virtualenvwrapper"
fi

# gcloud completion scripts via brew cask installation
if [ -f "$HOMEBREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then # brew cask installation
	source "$HOMEBREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
	source "$HOMEBREW/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
else
	log "WARNING: skipping loading gcloud completion"
fi

# iTerm2 integration
if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
else
  log "WARNING: skipping loading iterm2 shell integration"
fi

# GPG integration: https://gist.github.com/bmhatfield/cc21ec0a3a2df963bffa3c1f884b676b
if [ -f "$HOME/.gnupg/gpg_profile" ] && command -v gpg-agent > /dev/null; then
  source "$HOME/.gnupg/gpg_profile"
else
  log "WARNING: skipping loading gpg-agent"
fi


# kubectl completion (w/ refresh cache every 48-hours)
if command -v kubectl > /dev/null; then
	kcomp="$HOME/.kube/.zsh_completion"
	if [ ! -f "$kcomp" ] ||  [ "$(( $(date +"%s") - $(stat -c "%Y" "$kcomp") ))" -gt "172800" ]; then
		kubectl completion zsh > "$kcomp"
		log "refreshing kubectl zsh completion to $kcomp"
	fi
	source "$kcomp"
fi

# fzf completion. run $HOMEBREW/opt/fzf/install to create the ~/.fzf.* script
if type fzf &>/dev/null && [ -f ~/.fzf.zsh ]; then
	source ~/.fzf.zsh
else
	log "WARNING: skipping loading fzf.zsh"
fi

# kubectl aliases from https://github.com/ahmetb/kubectl-alias
#    > use sed to hijack --watch to watch $@.
[ -f ~/.kubectl_aliases ] && source <(cat ~/.kubectl_aliases | sed -r 's/(kubectl.*) --watch/watch \1/g')

# kube-ps1
if [[ -f "$HOMEBREW/opt/kube-ps1/share/kube-ps1.sh" ]]; then
	export KUBE_PS1_PREFIX='{'
	export KUBE_PS1_SUFFIX='}'
	source "$HOMEBREW/opt/kube-ps1/share/kube-ps1.sh"
	PROMPT="\$(kube_ps1)$PROMPT"
fi

# add dotfiles/bin to PATH
if [[ -d "/Users/$USER/workspace/dotfiles/bin" ]]; then
	PATH="/Users/$USER/workspace/dotfiles/bin:${PATH}"
fi

# load zsh plugins installed via brew
if [[ -d "$HOMEBREW/share/zsh-syntax-highlighting" ]]; then
	source "$HOMEBREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
if [[ -d "$HOMEBREW/share/zsh-autosuggestions" ]]; then
	source "$HOMEBREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# krew plugins
PATH="${KREW_ROOT:-$HOME/.krew}/bin:${PATH}"

# global ~/go/bin
PATH="${HOME}/go/bin:${PATH}"

# direnv hook
if command -v direnv > /dev/null; then
	eval "$(direnv hook zsh)"
fi

# nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# finally, export the PATH
export PATH
