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
plugins=(git brew sublime zsh-syntax-highlighting cloudapp docker docker-compose colorize colored-man-pages zsh-wakatime)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

source $ZSH/oh-my-zsh.sh

# Aliases 
alias cd..='cd ..'
alias ls='ls --color'
alias l='ls -lF'
alias dir='ls'
alias la='ls -lah'
alias ll='ls -l'
alias ls-l='ls -l'
alias vi=vim
alias grep='grep --color'
alias md='mkdir -p'
alias ping='ping -c 3'
alias serve=http-server
alias serve2='python -m SimpleHTTPServer 9009'
alias slp='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias bd='bg && disown %1'
alias d='docker'
alias dm='docker-machine'
alias pg='ps ax | grep -v "grep" | grep'
alias page='less -S'
alias start=open
alias tunneloff='networksetup -setsocksfirewallproxystate Wi-Fi off && echo Tunnel is turned off.'
alias tunnel='networksetup -setsocksfirewallproxystate Wi-Fi on && ssh -N -p 22 -D 8080 mine; networksetup -setsocksfirewallproxystate Wi-Fi off; echo Tunnel is turned off.'
alias fixvpn="sudo route -n flush && sudo networksetup -setv4off Wi-Fi && sudo networksetup -setdhcp Wi-Fi"
alias "docker ps"=docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Created}}'
alias git='hub'
alias gc='git commit -S -v -s'
alias o='less'
alias k='kubectl'
alias gpc='export GOPATH=`pwd`;export PATH=$PATH:$HOME/gotools:$GOPATH/bin;code .'


retry() {
    while true; do $@; sleep 1; done
}

# coreutils
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# virtualenv
export WORKON_HOME=$HOME/workspace/.virtualenvs
source "/usr/local/bin/virtualenvwrapper.sh"

# gcloud
# export PATH=$PATH:/Users/$USER/google-cloud-sdk/bin
source /Users/$USER/google-cloud-sdk/completion.zsh.inc
if [ -f "/Users/$USER/google-cloud-sdk/completion.zsh.inc" ]; then
  source "/Users/$USER/google-cloud-sdk/completion.zsh.inc"
fi

# gpg signing stuff https://github.com/pstadler/keybase-gpg-github
GPG_TTY=$(tty)
export GPG_TTY
if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
  source ~/.gnupg/.gpg-agent-info
  export GPG_AGENT_INFO
else
  eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
fi

# iterm2 integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/$USER/google-cloud-sdk/path.zsh.inc ]; then
  source "/Users/$USER/google-cloud-sdk/path.zsh.inc"
fi
