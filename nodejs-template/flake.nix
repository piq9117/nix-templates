{
  description = "Basic nodejs template";

  inputs.nixpkgs.url = "nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }:

    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      });

    in
    {
      overlay = final: prev: {
        init-project = final.writeScriptBin "init-project" ''
          ${final.nodePackages_latest.npm}/bin/npm init --y
          ${final.nodePackages_latest.npm}/bin/npm install @tsconfig/node20 ts-node
        '';
      };

      packages = forAllSystems (system: { });

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs_20
              nodePackages_latest.npm
              nodePackages_latest.pnpm
              nodePackages_latest.prettier
              treefmt
              typescript
              init-project
            ];

            shellHook = "export PS1='[$PWD]\n❄ '";
          };
        }
      );
    };
}
