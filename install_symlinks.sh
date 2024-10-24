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
	.tmux.conf; do
	if [ -e "$HOME/$f" ]; then rm "$HOME/$f"; fi
	ln -sf "$SCRIPT_DIR/$f" "$HOME/$f"
done

# Ghostty config file
ghostty_config="$HOME/.config/ghostty/config"
if [[ -e "$ghostty_config" ]]; then
    unlink "$ghostty_config"
fi
mkdir -p "$(dirname "$ghostty_config")"
ln -sf -- "$SCRIPT_DIR/ghostty_config" "$ghostty_config"


# if [[ $(uname) == Darwin ]]; then
#    # install iterm2 shell integration (for touchbar support etc)
#     # (later sourced in .zshrc)
#     curl -LfsS https://iterm2.com/shell_integration/zsh \
#         -o ~/.iterm2_shell_integration.zsh
# fi

echo "DONE"
