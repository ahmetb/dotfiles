#!/bin/bash
set -eou pipefail
IFS=$'\n\t'
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

touch ~/.hushlogin

set -x
for f in .zshrc \
	.vimrc \
	.editorconfig \
	.github_username \
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
