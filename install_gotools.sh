#!/bin/bash
IFS=$'\n\t'
set -xeou pipefail

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

	# vim-go
	github.com/jstemmer/gotags \
	github.com/klauspost/asmfmt/cmd/asmfmt \
	github.com/alecthomas/gometalinter \
	golang.org/x/tools/cmd/goimports \
	github.com/kisielk/errcheck \
	github.com/fatih/motion \
	github.com/fatih/gomodifytags \
	github.com/zmb3/gogetdoc \
	github.com/josharian/impl \
	github.com/dominikh/go-tools/cmd/keyify \

	# other go dev
	github.com/kardianos/govendor \
	github.com/tools/godep \
	github.com/golang/dep/cmd/dep \
	github.com/golang/protobuf/protoc-gen-go

	# misc
	github.com/shurcooL/markdownfmt
	)
GOPATH="$GOTOOLS" go get -u "${GOPKGS[@]}"
