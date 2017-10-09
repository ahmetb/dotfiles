#!/bin/bash
IFS=$'\n\t'
set -xeou pipefail

if [ -f /usr/local/bin/goclone ]; then
	sudo unlink /usr/local/bin/goclone
fi
sudo ln -s /Users/$USER/workspace/goclone/goclone /usr/local/bin/goclone

GOTOOLS=~/gotools
mkdir -p "$GOTOOLS"
GOPKGS=(
	# vscode-go tools
	github.com/nsf/gocode \
	github.com/tpng/gopkgs \
	github.com/ramya-rao-a/go-outline \
	github.com/acroca/go-symbols \
	golang.org/x/tools/cmd/guru \
	golang.org/x/tools/cmd/gorename \
	github.com/rogpeppe/godef \
	github.com/golang/lint/golint \
	github.com/cweill/gotests/... \
	sourcegraph.com/sqs/goreturns \
	golang.org/x/tools/cmd/goimports \
	github.com/fatih/gomodifytags \
	github.com/josharian/impl \

	# other go dev
	github.com/kardianos/govendor \
	github.com/tools/godep \
	github.com/golang/dep/cmd/dep \
	github.com/golang/protobuf/protoc-gen-go \

	# misc
	github.com/jessfraz/reg \
	github.com/shurcooL/markdownfmt \
	github.com/cpuguy83/go-md2man
	)

GOPATH="$GOTOOLS" go get -u -v "${GOPKGS[@]}"

