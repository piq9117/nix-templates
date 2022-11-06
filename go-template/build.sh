#!/usr/bin/env nix-shell
#!nix-shell -p go -i bash

GITROOT=$(git rev-parse --show-toplevel)

go build $(find $GITROOT -type f -name "main.go")
