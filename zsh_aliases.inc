# This script is sourced from .zshrc.

# Add GNU tools not linked by Homebrew.
alias find='gfind'
alias xargs='gxargs'
alias stat='gstat'

# Tool overrides
alias watch='viddy'
alias ssh='ssh -o StrictHostKeyChecking=no'

# Github Copilot aliases
alias '??'='gh copilot suggest -t shell'
alias 'git?'='gh copilot suggest -t git'
alias 'gh?'='gh copilot suggest -t gh'
alias 'explain'='gh copilot explain'

# convenience aliases
local LS=ls
if [[ -z ${commands[gls]} ]]; then
    LS='gls'
fi

alias cd..='cd ..'
alias cd...='cd ../..'
alias ls="$LS --color=auto"
alias l='ls -lF'
alias dir='ls'
alias la='ls -lah'
alias ll='ls -l'
alias ls-l='ls -l'
alias j='jobs'
alias time='gtime --format "$(tput setab 255)$(tput setaf 160)took %es.$(tput sgr0)"'
# alias vi='lvim'
alias grep='grep -E --color'
alias ping='ping -c 3'
alias pstree='pstree -w'
alias c='pbcopy'
alias p='pbpaste'
alias pt='pbpaste | tee'
alias pate='tee /dev/stderr | pasteit'
alias t='tee'
alias slp='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias bd='bg && disown %1'
alias pg='ps ax | grep -v "grep" | grep'
alias o='less'
alias no='yes n'
alias cl='clear;clear'
alias page='less -S'
alias start=open
alias ccat='ccat --bg=dark'
alias c.='code .'
alias i.='idea .'
alias idea.='idea .'
alias code.='code .'
alias fd='fd --no-ignore'
alias ag='ag --hidden'
alias yl='jless --yaml'
alias yless='jless --yaml'

# cloud stuff
alias d='docker'
alias dr='docker run --rm -i -t'
alias drb='docker run --rm -i -t --entrypoint sh'
alias drr='docker run --rm -i -t -p 8080:8080 -e PORT=8080'
alias dx='docker exec -i -t'
alias db='docker build -t'

# google cloud platform
alias gcurl='curl -k --header "Authorization: Bearer $(gcloud auth print-access-token -q)"'
alias runcurl='curl -k --header "Authorization: Bearer $(gcloud auth print-identity-token -q)"'
alias gke='gcloud container clusters'
alias gkedel='gcloud container clusters delete -q --async'
alias gce='gcloud compute instances'
alias gcssh='gcloud compute ssh'
alias runlist='gcloud run services list --platform=managed'
alias rundel='gcloud run services delete -q --platform=managed --region us-central1'

# git aliases
alias gc='_git_dbg commit -v'
alias gdc='_git_dbg diff --cached'
alias gpp='_git_dbg push ahmetb HEAD && hub pull-request --browse'
alias gpah='_git_dbg push ahmetb HEAD'
alias glah='_git_dbg pull ahmetb HEAD'
alias gfah='_git_dbg fetch ahmetb'
alias glom='_git_dbg pull origin master --tags'
alias gloh='_git_dbg pull origin HEAD --tags'
alias grom='_git_dbg rebase origin/master'
alias gpoh='_git_dbg push origin HEAD'
alias gcae='_git_dbg commit --amend --edit'
alias gbv="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gitroot='cd $(git rev-parse --show-toplevel)'

# kubectl
alias kcx='kubectx'
alias kns='kubens'
alias kx='kubectl explain'
alias pka='pbpaste | kubectl apply -f-'
alias pkr='pbpaste | kubectl delete -f-'
alias pkd='pbpaste | kubectl describe -f-'
alias kpl='kubectl plugin'
alias krew_install_clipboard='kubectl krew install --manifest <(pbpaste)'
alias kk='kubectl krew'

# github aliases
alias prc='gh pr create --web'
alias prd='gh pr create --draft --web'
alias prw='gh pr view --web'
alias prco='gh pr checkout'
alias prl='gh pr list -s all'
alias prme='prl --author @me'
alias ghb='gh browse'

# misc shortcuts
alias tunneloff='networksetup -setsocksfirewallproxystate Wi-Fi off && echo Tunnel is turned off.'
alias tunnel='networksetup -setsocksfirewallproxystate Wi-Fi on && ssh -N -p 22 -D 8080 mine; networksetup -setsocksfirewallproxystate Wi-Fi off; echo Tunnel is turned off.'
# alias ffmpeg='docker run --rm -i -t -v $PWD:/tmp/workdir jrottenberg/ffmpeg'
# alias youtube-dl='docker run --rm -i -t -v $PWD:/data vimagick/youtube-dl'
alias decodecert='openssl x509 -in /dev/stdin -text -noout'
