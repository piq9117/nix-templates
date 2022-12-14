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
    };
  };
}
