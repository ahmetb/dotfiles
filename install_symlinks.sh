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
	.git-commit-template \
	.gitignore_global \
	.kubectl_aliases \
	.oh-my-posh.omp.yaml \
	.claude.omp.yaml \
	.tmux.conf; do
	if [ -e "$HOME/$f" ]; then rm "$HOME/$f"; fi
	ln -sf "$SCRIPT_DIR/$f" "$HOME/$f"
done

# Ghostty config file
ghostty_config="/Users/$USER/Library/Application Support/com.mitchellh.ghostty/config"
if [[ -e "$ghostty_config" ]]; then
    unlink "$ghostty_config"
fi
mkdir -p "$(dirname "$ghostty_config")"
ln -sf -- "$SCRIPT_DIR/ghostty_config" "$ghostty_config"

echo "DONE"
