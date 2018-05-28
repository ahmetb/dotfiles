export ZSH=/Users/$USER/.oh-my-zsh

ZSH_THEME="robbyrussell"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="false"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git docker colored-man-pages zsh-completions)

# User configuration
export EDITOR=vim

source $ZSH/oh-my-zsh.sh

# Use userland brew path, if exists
export HOMEBREW="$HOME/.homebrew"
if [ ! -d $HOMEBREW ]; then
  # fallback
  export HOMEBREW=/usr/local
fi
PATH="$HOMEBREW/bin:$HOMEBREW/sbin:$PATH"

# Add zsh completion scripts installed via Homebrew
fpath=("$HOMEBREW/share/zsh/site-functions" $fpath)

# Reload the zsh-completions
autoload -U compinit && compinit

# Misc functions
retry() {
  while true; do $@; sleep 1; done
}

til() {
  while true; do $@; if [ $? -eq 0 ]; then break; fi; sleep 1; done
}

mcd() {
  mkdir -p "${1:?Need to specify an argument}" && cd "$1"
}

goto() {
  cd $(dirname $(readlink -f $(which "$@")))
}

portkill() {
  ps="$(lsof -t -i:$1)"
  if [[ -z "$ps" ]]; then
    echo "no processes found"
  else
    kill -9 $ps && echo $ps
  fi
}

measure() {
  local ts=$(date +%s%N)
  $@
  local tt=$((($(date +%s%N) - $ts)/1000000))
  echo "time took: $tt ms." >&2
}

# Custom aliases 
alias cd..='cd ..'
alias ls='ls --color'
alias l='ls -lF'
alias dir='ls'
alias la='ls -lah'
alias ll='ls -l'
alias ls-l='ls -l'
alias j='jobs'
alias vi='vim'
alias grep='grep -E --color'
alias ping='ping -c 3'
alias pstree='pstree -w'
alias c='pbcopy'
alias p='pbpaste'
alias pka='pbpaste | kubectl apply -f-'
alias pt='pbpaste | tee'
alias kx='kubectl explain'
alias t='tee'
alias slp='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias bd='bg && disown %1'
alias pg='ps ax | grep -v "grep" | grep'
alias o='less'
alias no='yes n'
alias page='less -S'
alias start=open
alias ccat='ccat --bg=dark'
# cloud stuff
alias d='docker'
alias dr='docker run --rm -i -t'
alias dm='docker-machine'
alias gke='gcloud container clusters'
alias gkedel='gcloud container clusters delete -q --async'
alias gce='gcloud compute instances'
alias gcssh='gcloud compute ssh'
# git aliases
alias gc='git commit -S -v -s'
alias gdc='git diff --cached'
alias git='hub'
alias gpp='git push ahmetb HEAD && hub pull-request --browse'
alias gpah='git push ahmetb HEAD'
alias glah='git pull ahmetb HEAD'
alias gfah='git fetch ahmetb'
alias glom='git pull origin master'
alias grom='git rebase origin/master'
alias gpoh='git push origin HEAD'
unalias grv
# misc shortcuts
alias tunneloff='networksetup -setsocksfirewallproxystate Wi-Fi off && echo Tunnel is turned off.'
alias tunnel='networksetup -setsocksfirewallproxystate Wi-Fi on && ssh -N -p 22 -D 8080 mine; networksetup -setsocksfirewallproxystate Wi-Fi off; echo Tunnel is turned off.'
alias ffmpeg='docker run --rm -i -t -v $PWD:/tmp/workdir jrottenberg/ffmpeg'

func gcr() {
    [ -n "$1" ] && [[ ! "$1" =~ ^gcr.io ]] && 1="gcr.io/$1"
    c=$(echo "$1" | grep -o \/ | wc -l)
    if [[ 1 == $c ]]; then gcloud container images list --repository "$1" --limit=99999
    elif [[ 2 == $c ]]; then gcloud container images list-tags "$1" --limit=99999
    else; gcloud container images list; fi
}

# PATH MANIPULATIONS
# coreutils
MANPATH="$HOMEBREW/opt/coreutils/libexec/gnuman:$MANPATH"
PATH="$HOMEBREW/opt/coreutils/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-getopt/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-indent/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/grep/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/ncurses/bin:$PATH"
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
fi

# gcloud completion scripts via brew cask installation
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then # brew cask installation
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# iTerm2 integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# GPG integration: https://gist.github.com/bmhatfield/cc21ec0a3a2df963bffa3c1f884b676b
if [ -f "$HOME/.gnupg/gpg_profile" ]; then
  source "$HOME/.gnupg/gpg_profile"
fi


# kubectl completion (currently sourcing this is not needed because brew pkg brings completion script)
# source <(kubectl completion zsh)

# fzf completion. run $HOMEBREW/opt/fzf/install to create the ~/.fzf.* script
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# kubectl aliases from https://github.com/ahmetb/kubectl-alias
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
# func kubectl(){ echo "$(tput setaf 3)+ kubectl $@ $(tput sgr0)"; command kubectl $@ }

# kube-ps1
if [[ -f "$HOMEBREW/opt/kube-ps1/share/kube-ps1.sh" ]]; then
	export KUBE_PS1_PREFIX='{'
	export KUBE_PS1_SUFFIX='}'
	source "$HOMEBREW/opt/kube-ps1/share/kube-ps1.sh"
	PROMPT="\$(kube_ps1) $PROMPT"
fi

# add dotfiles/bin to PATH
if [[ -d "/Users/$USER/workspace/dotfiles/bin" ]]; then
	PATH="/Users/$USER/workspace/dotfiles/bin:${PATH}"
fi

# finally, export the PATH
export PATH="$PATH"

