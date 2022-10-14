{
  description = "A very basic flake";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});

    in {
      devShells = forAllSystems(system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            packages = [];
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