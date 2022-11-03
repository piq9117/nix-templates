{
  description = "Basic go template";

  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [];
      });

    in {
      overlay = final: prev: {};
      packages = forAllSystems (system: {});
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {

          buildInputs = with pkgs; [
              go
              gopls
              gotools
              go-tools
            ];
          shellHook = "export PS1='[$PWD]\n❄ '";
          };
        });
    };
}
