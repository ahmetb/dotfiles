#!/bin/bash
IFS=$'\n\t'
set -xeou pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# suppress shell login message
[[ ! -f ~/.hushlogin ]] && touch ~/.hushlogin

# install go-based tools
for f in .zshrc \
	.Brewfile \
	.vimrc \
	.editorconfig \
	.github_username \
	.gitignore_global \
	.tmux.conf; do
	if [ -f "$HOME/$f" ]; then rm "$HOME/$f"; fi
	ln -sf "$SCRIPT_DIR/$f" "$HOME/$f"
done

# gnupg
if [ -f "$HOME/.gnupg" ] && [ ! -L "$HOME/.gnupg" ];then
	echo "$HOME/.gnupg is not a symlink. Delete it manually."
	exit 1
else
	[ -L "$HOME/.gnupg" ] && unlink "$HOME/.gnupg"
	ln -sf "$SCRIPT_DIR/.gnupg" "$HOME/.gnupg"
fi

# install zsh-completions
ZSH_COMPLETIONS=~/.oh-my-zsh/custom/plugins/zsh-completions
[[ -d "$ZSH_COMPLETIONS" ]] || git clone \
	https://github.com/zsh-users/zsh-completions "$ZSH_COMPLETIONS"

# git setup
git config --global core.excludesfile ~/.gitignore_global
