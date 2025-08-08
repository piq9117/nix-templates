{
  description = "Piq's flake templates";

  outputs = { self, nixpkgs }: {

    templates = {
      haskell-cabal = {
        path = ./haskell-cabal-template;
        description = "Cabal project template";
      };

      haskell-stack = {
        path = ./haskell-stack-template;
        description = "Stack project template";
      };

      nodejs = {
        path = ./nodejs-template;
        description = "Nodejs project template";
      };

      go = {
        path = ./go-template;
        description = "Go project template";
      };

      # This information was from https://xeiaso.net/blog/nix-flakes-go-programs/
      gomod2nix = {
        path = ./gomod2nix-template;
        description = "Gomod2nix project template";
      };

      ocaml = {
        path = ./ocaml-template;
        description = "OCaml project template";
      };

      purescript = {
        path = ./purescript-template;
        description = "Purescript project template";
      };

      react-nextjs = {
        path = ./react-nextjs-template;
        description = "React NextJS Template";
      };

      react-ts = {
        path = ./react-ts-template;
        description = "React TS Template";
      };

      react-js = {
        path = ./react-js-template;
        description = "React JS Template";
      };

      scala = {
        path = ./scala-template;
        description = "Scala Template";
      };
    };
  };
}
