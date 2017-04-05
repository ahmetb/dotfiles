#!/bin/bash
IFS=$'\n\t'
set -xeou pipefail

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
