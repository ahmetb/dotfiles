#!/bin/bash
IFS=$'\n\t'
set -xeou pipefail

GOTOOLS=~/gotools
mkdir -p "$GOTOOLS"
GOPKGS=(
	# vscode-go tools
	# from https://github.com/Microsoft/vscode-go/blob/master/src/goInstallTools.ts
	github.com/acroca/go-symbols \
	github.com/alecthomas/gometalinter \
	github.com/cweill/gotests/... \
	github.com/derekparker/delve/cmd/dlv \
	github.com/fatih/gomodifytags \
	github.com/golang/lint/golint \
	github.com/haya14busa/goplay/cmd/goplay \
	github.com/josharian/impl \
	github.com/nsf/gocode \
	github.com/ramya-rao-a/go-outline \
	github.com/rogpeppe/godef \
	github.com/sourcegraph/go-langserver \
	github.com/tylerb/gotype-live \
	github.com/uudashr/gopkgs/cmd/gopkgs \
	github.com/zmb3/gogetdoc \
	golang.org/x/tools/cmd/godoc \
	golang.org/x/tools/cmd/goimports \
	golang.org/x/tools/cmd/gorename \
	golang.org/x/tools/cmd/guru \
	honnef.co/go/tools/... \
	sourcegraph.com/sqs/goreturns \
	github.com/davidrjenni/reftools/cmd/fillstruct \

	# other go dev
	github.com/kardianos/govendor \
	github.com/tools/godep \
	github.com/Masterminds/glide \
	github.com/golang/dep/cmd/dep \
	github.com/golang/protobuf/protoc-gen-go \
	github.com/spf13/cobra/cobra \
	github.com/ahmetb/govvv \

	# misc
	github.com/shurcooL/markdownfmt \
	github.com/cpuguy83/go-md2man \
	golang.org/x/vgo \
	github.com/rakyll/hey \
	github.com/ahmetb/iamutil
	)

GOPATH="$GOTOOLS" go get -u "${GOPKGS[@]}"

