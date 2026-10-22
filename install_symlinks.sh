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

# Vim config directory
if [ -e "$HOME/.vim" ] || [ -L "$HOME/.vim" ]; then rm -rf "$HOME/.vim"; fi
ln -sf "$SCRIPT_DIR/.vim" "$HOME/.vim"

# Ghostty config file (macOS only)
if [[ "$(uname -s)" == "Darwin" ]]; then
    ghostty_config="/Users/$USER/Library/Application Support/com.mitchellh.ghostty/config"
    if [[ -e "$ghostty_config" ]] || [[ -L "$ghostty_config" ]]; then
        unlink "$ghostty_config"
    fi
    mkdir -p "$(dirname "$ghostty_config")"
    ln -sf -- "$SCRIPT_DIR/ghostty_config" "$ghostty_config"
fi

# Claude config directory (symlink files preserving directory structure)
while IFS= read -r -d '' f; do
	relative="${f#$SCRIPT_DIR/.claude/}"
	case "$relative" in
		skills/*) continue ;;
	esac
	parent="$HOME/.claude/$(dirname "$relative")"
	if [ -L "$parent" ]; then
		continue
	fi
	target="$HOME/.claude/$relative"
	mkdir -p "$(dirname "$target")"
	if [ -e "$target" ] || [ -L "$target" ]; then rm "$target"; fi
	ln -sf "$f" "$target"
done < <(find "$SCRIPT_DIR/.claude" -type f -print0)

# opencode config files (symlink files preserving directory structure)
while IFS= read -r -d '' f; do
	relative="${f#$SCRIPT_DIR/.config/opencode/}"
	target="$HOME/.config/opencode/$relative"
	mkdir -p "$(dirname "$target")"
	if [ -e "$target" ] || [ -L "$target" ]; then rm "$target"; fi
	ln -sf "$f" "$target"
done < <(find "$SCRIPT_DIR/.config/opencode" -type f ! -name package.json ! -name package-lock.json -print0)

# Claude skills directory (symlink the whole directory)
if [ -e "$HOME/.claude/skills" ] || [ -L "$HOME/.claude/skills" ]; then rm -rf "$HOME/.claude/skills"; fi
ln -sf "$SCRIPT_DIR/.claude/skills" "$HOME/.claude/skills"

echo "DONE"
