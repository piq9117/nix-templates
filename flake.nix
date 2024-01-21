{
  description = "Piq's flake templates";

  outputs = { self, nixpkgs }: {

    templates = {
      haskell-cabal = {
        path = ./haskell-cabal-template;
        description = "Cabal project template";
      };

      nodejs = {
        path = ./nodejs-template;
        description = "Nodejs project template";
      };

      go = {
        path = ./go-template;
        description = "Go project template";
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

      react = {
        path = ./react-template;
        description = "React Template";
      };
    };
  };
}
