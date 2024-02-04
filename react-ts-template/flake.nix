{
  description= "React Template";
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = {self, nixpkgs}:
    let supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

        forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

        nixpkgsFor = forAllSystems (system: import nixpkgs {
          inherit system;
          overlays = [self.overlay];
        });

    in {
      overlay = final: prev: {
        generate-vite-app = final.writeScriptBin "generate-vite-app" ''
          ${final.nodePackages_latest.pnpm}/bin/pnpm create vite . --template react-ts
          ${final.nodePackages_latest.pnpm}/bin/pnpm install
        '';
      };
      devShells = forAllSystems(system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs_20
              nodePackages_latest.npm
              nodePackages_latest.pnpm
              nodePackages.prettier
              treefmt
              generate-vite-app
            ];

            shellHook = ''
              export PS1='[$PWD]\n❄ '
              #!/usr/bin/env bash
            '';
          };
        });
    };

}
