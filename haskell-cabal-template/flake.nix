{
  description = "Cabal project scaffold";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = ["x86_64-linux" "x86_64-darwin"];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [self.overlay];
      });
    in {
      overlay = (final: prev: {
        haskell-cabal = final.haskellPackages.callCabal2nix "haskell-cabal" ./. {};
      });
      packages = forAllSystems (system: {
        haskell-cabal = nixpkgsFor.${system}.haskell-cabal;
      });
      defaultPackage = forAllSystems (system: self.packages.${system}.haskell-cabal);
      # checks = self.packages;
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            packages = [self.packages.${system}.haskell-cabal];
            buildInputs = with pkgs; [
              cabal-install
              haskell.compiler.ghc924
              ghcid
            ];
          shellHook = "export PS1='\\e[1;34mdev > \\e[0m'";
          };
      });
    };
}
