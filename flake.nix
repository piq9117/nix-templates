{
  description = "Piq's flake templates";

  outputs = { self, nixpkgs }: {

    templates = {
      haskell-cabal = {
        path = ./haskell-cabal-template;
        description = "Cabal project environment";
      };
    };
  };
}
