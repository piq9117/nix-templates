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
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          go = pkgs.go_1_18;
        in {
          build-all = pkgs.writeShellScriptBin "build-all" ''
            GITROOT=$(git rev-parse --show-toplevel)
            ${go}/bin/go build -o $GITROOT/$(basename $GITROOT) $(find $GITROOT -type f -name "main.go")
          '';

          run-package = pkgs.writeShellScriptBin "run" ''
            GITROOT=$(git rev-parse --show-toplevel)
            ${go}/bin/go run "$@".go
          '';

          run-main = nixpkgsFor.${system}.writeShellScriptBin "run-main" ''
            GITROOT=$(git rev-parse --show-toplevel)
            ${go}/bin/go run $GITROOT/main.go
          '';

      });
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            packages = [
              self.packages.${system}.build-all
              self.packages.${system}.run-package
            ];
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
