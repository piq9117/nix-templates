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

### Nix Community

``` sh
nix flake init -t github:nix-community/gomod2nix#app
```
add everything in git with `git add .`

Add gomod2nix input

``` nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
  };
}
```
Then declare `gomod2nix` in outputs

``` nix
outputs = { self, nixpkgs, utils, gomod2nix }:
```
This information was from https://xeiaso.net/blog/nix-flakes-go-programs/

`go-hello` template

``` sh
nix flake new -t templates#go-hello .
```

## Purescript

``` sh
nix flake init -t "github:piq9117/nix-templates#purescript"
```

## OCaml

``` sh
nix flake init -t "github:piq9117/nix-templates#ocaml"
```

## React NextJS
``` sh
nix flake init -t "github:piq9117/nix-templates#react-nextjs"
```

## React 
``` sh
nix flake init -t "github:piq9117/nix-templates#react"
```
