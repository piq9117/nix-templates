#!/usr/bin/env nix-shell
#!nix-shell -p go -i bash

GITROOT=$(git rev-parse --show-toplevel)

go run $GITROOT/main.go
