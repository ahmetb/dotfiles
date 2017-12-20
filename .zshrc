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
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
if [ -n "$EXTRA_PATH" ]; then
     export PATH="$EXTRA_PATH:$PATH"
fi

export EDITOR=vim

source $ZSH/oh-my-zsh.sh

# Use userland brew path, if exists
export HOMEBREW="$HOME/.homebrew"
if [ ! -d $HOMEBREW ]; then
  # fallback
  export HOMEBREW=/usr/local
fi
export PATH="$HOMEBREW/bin:$HOMEBREW/sbin:$PATH"

# Add zsh completion scripts installed via Homebrew
fpath=("$HOMEBREW/share/zsh/site-functions" $fpath)

# Reload the zsh-completions
autoload -U compinit && compinit

# Misc functions
retry() {
  while true; do $@; sleep 1; done
}

mcd() {
  mkdir -p "$1" && cd "$1"
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
alias grep='grep --color'
alias ping='ping -c 3'
alias pstree='pstree -w'
alias c='pbcopy'
alias p='pbpaste'
alias t='tee'
alias slp='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias bd='bg && disown %1'
alias pg='ps ax | grep -v "grep" | grep'
alias o='less'
alias page='less -S'
alias start=open
alias ccat='ccat --bg=dark'
# cloud stuff
alias d='docker'
alias dr='docker run --rm -i -t'
alias dm='docker-machine'
alias gke='gcloud container clusters'
alias gce='gcloud compute instances'
# git aliases
alias gc='git commit -S -v -s'
alias gdc='git diff --cached'
alias git='hub'
alias gpp='git push ahmetb HEAD && hub pull-request'
alias gpah='git push ahmetb HEAD'
alias glah='git pull ahmetb HEAD'
alias gfah='git fetch ahmetb'
alias glom='git pull origin master'
alias grom='git rebase origin/master'
# misc shortcuts
alias tunneloff='networksetup -setsocksfirewallproxystate Wi-Fi off && echo Tunnel is turned off.'
alias tunnel='networksetup -setsocksfirewallproxystate Wi-Fi on && ssh -N -p 22 -D 8080 mine; networksetup -setsocksfirewallproxystate Wi-Fi off; echo Tunnel is turned off.'
alias ffmpeg='docker run --rm -i -t -v $PWD:/tmp/workdir jrottenberg/ffmpeg'

# PATH MANIPULATIONS
# coreutils
MANPATH="$HOMEBREW/opt/coreutils/libexec/gnuman:$MANPATH"
PATH="$HOMEBREW/opt/coreutils/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-getopt/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-indent/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="$HOMEBREW/opt/ncurses/bin:$PATH"
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
#  or just this: export PATH=$PATH:/Users/$USER/google-cloud-sdk/bin
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
func kubectl(){ echo "+ kubectl $@"; command kubectl $@ }

# kube-ps1
# currently disabled b/c adds 200 ms delay to every shell prompt
#if [[ -f "$HOME/workspace/dotfiles/kube-ps1.sh" ]]; then
#	source "$HOME/workspace/dotfiles/kube-ps1.sh"
#	PROMPT="\$(kube_ps1) $PROMPT"
#fi

# finally, export the PATH
export PATH="$PATH"
