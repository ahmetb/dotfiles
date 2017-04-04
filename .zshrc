# Path to your oh-my-zsh installation.
export ZSH=/Users/$USER/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

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

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sublime zsh-syntax-highlighting cloudapp docker kubectl colorize colored-man-pages zsh-completions)

# Reload the zsh-completions
autoload -U compinit && compinit

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export EDITOR=vim

source $ZSH/oh-my-zsh.sh

# Aliases 
alias cd..='cd ..'
alias ls='ls --color'
alias l='ls -lF'
alias dir='ls'
alias la='ls -lah'
alias ll='ls -l'
alias ls-l='ls -l'
alias j='jobs'
alias vi=vim
alias grep='grep --color'
alias md='mkdir -p'
alias ping='ping -c 3'

alias slp='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias bd='bg && disown %1'
alias pg='ps ax | grep -v "grep" | grep'
alias o='less'
alias page='less -S'
alias start=open
alias tunneloff='networksetup -setsocksfirewallproxystate Wi-Fi off && echo Tunnel is turned off.'
alias tunnel='networksetup -setsocksfirewallproxystate Wi-Fi on && ssh -N -p 22 -D 8080 mine; networksetup -setsocksfirewallproxystate Wi-Fi off; echo Tunnel is turned off.'

alias d='docker'
alias dm='docker-machine'
alias k='kubectl'

alias gpc='export GOPATH=`pwd`;export PATH=$PATH:$HOME/gotools:$GOPATH/bin;code .'
alias gc='git commit -S -v -s'
alias gdc='git diff --cached'
alias git='hub'

retry() {
  while true; do $@; sleep 1; done
}

mcd() {
  mkdir -p "$1" && cd "$1"
}

# coreutils
#   To install: brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gnu-getopt/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gnu-indent/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# virtualenv
if [ -f "/usr/local/bin/virtualenvwrapper.sh" ]; then
  export WORKON_HOME=$HOME/workspace/.virtualenvs
  source "/usr/local/bin/virtualenvwrapper.sh"
fi

# gcloud
#  or just this: export PATH=$PATH:/Users/$USER/google-cloud-sdk/bin
if [ -f "/Users/$USER/google-cloud-sdk/completion.zsh.inc" ]; then # manual installatioon
  source "/Users/$USER/google-cloud-sdk/completion.zsh.inc"
fi
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

# go tools path
export PATH="$PATH:$HOME/gotools/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
