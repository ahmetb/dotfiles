#!/bin/bash
set -eou pipefail
IFS=$'\n\t'
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set -x

# suppress shell login message
touch ~/.hushlogin

# disable smart quotes and dashes
defaults write 'Apple Global Domain' NSAutomaticDashSubstitutionEnabled 0
defaults write 'Apple Global Domain' NSAutomaticQuoteSubstitutionEnabled 0

# install go-based tools
GOTOOLS=~/gotools
mkdir -p "$GOTOOLS"
GOPKGS=(
	# vscode-go tools
	github.com/nsf/gocode \
	github.com/tpng/gopkgs \
	github.com/lukehoban/go-outline \
	github.com/acroca/go-symbols \
	golang.org/x/tools/cmd/guru \
	golang.org/x/tools/cmd/gorename \
	github.com/rogpeppe/godef \
	github.com/golang/lint/golint \
	github.com/cweill/gotests/... \
	sourcegraph.com/sqs/goreturns \
	golang.org/x/tools/cmd/goimports \

	# other go dev
	github.com/kardianos/govendor \

	# misc
	github.com/shurcooL/markdownfmt
	)
GOPATH="$GOTOOLS" go get -u "${GOPKGS[@]}"

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
