#!/bin/bash
set -eou pipefail
IFS=$'\n\t'
readonly SCRIPT_DIR=$(realpath $(dirname $(readlink -f $0)))

touch ~/.hushlogin

set -x
for f in .zshrc \
	.vimrc \
	.editorconfig \
	.github_username \
	.tmux.conf; do
	unlink "$HOME/$f"
	ln -s "$SCRIPT_DIR/$f" "$HOME/$f"
done

# gnupg
if [ -f "$HOME/.gnupg" ] && [ ! -L "$HOME/.gnupg" ];then
	echo "$HOME/.gnupg is not a symlink. Delete it manually."
	exit 1
else
	[ -L "$HOME/.gnupg" ] && unlink "$HOME/.gnupg"
	ln -s "$SCRIPT_DIR/.gnupg" "$HOME/.gnupg"
fi
