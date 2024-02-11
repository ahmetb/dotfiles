#!/bin/bash
IFS=$'\n\t'
set -xeou pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# suppress shell login message
[[ ! -e ~/.hushlogin ]] && touch ~/.hushlogin

for f in .zshrc \
	.Brewfile \
	.vimrc \
	.ideavimrc \
	.editorconfig \
	.gitconfig \
	.gitignore_global \
	.kubectl_aliases \
	.oh-my-posh.omp.yaml \
	.tmux.conf; do
	if [ -e "$HOME/$f" ]; then rm "$HOME/$f"; fi
	ln -sf "$SCRIPT_DIR/$f" "$HOME/$f"
done

ZSH_PLUGINS=~/.oh-my-zsh/custom/plugins
mkdir -p "$ZSH_PLUGINS"

# install zsh-completions plugin
ZSH_COMPLETIONS="$ZSH_PLUGINS/zsh-completions"
[[ -d "$ZSH_COMPLETIONS" ]] || git clone \
	https://github.com/zsh-users/zsh-completions "$ZSH_COMPLETIONS"

# install evalcache plugin
ZSH_EVALCACHE="$ZSH_PLUGINS/evalcache"
[[ -d "$ZSH_EVALCACHE" ]] || git clone \
	https://github.com/mroth/evalcache "$ZSH_EVALCACHE"

if [[ $(uname) == Darwin ]]; then
    # install iterm2 shell integration (for touchbar support etc)
    # (later sourced in .zshrc)
    curl -LfsS https://iterm2.com/shell_integration/zsh \
        -o ~/.iterm2_shell_integration.zsh
fi

echo "DONE"
