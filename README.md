# piq's flake templates
When the template has been cached, throw a `--refresh` flag when initializing.

## haskell with cabal

``` sh
nix flake init -t "github:piq9117/nix-templates#haskell-cabal"
```


## Nodejs

``` sh
nix flake init -t "github:piq9117/nix-templates#nodejs"
```

## Go

``` sh
nix flake init -t "github:piq9117/nix-templates#go"
```
Give `build.sh` and `run.sh` permission.

## Purescript

Use [purs-nix](https://github.com/purs-nix/purs-nix)
