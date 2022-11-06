#!/usr/bin/env nix-shell
#!nix-shell -p go -i bash

GITROOT=$(git rev-parse --show-toplevel)

go build -o $GITROOT/$(basename $GITROOT) $(find $GITROOT -type f -name "main.go")
