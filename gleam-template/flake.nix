{
  description = "gleam template";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nix-gleam.url = github:arnarg/nix-gleam;
  };

  outputs = { self, nixpkgs, nix-gleam }: 
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      nixpkgsFor = forAllSystems(system: import nixpkgs {
        inherit system;
        overlays = [ self.overlays nix-gleam.overlays.default ];

      });
    in {
      overlays = final: prev: {
        # gleam application
        # update the name matching your project
        my-project = final.buildGleamApplication {
          pname = "my-project";
          version = "latest";
          src = ./.;
        };
      };

      packages = forAllSystems(system: 
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.my-project;
        });

      devShells = forAllSystems(system: 
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              gleam
              beamPackages.erlang
              beamPackages.rebar3

              treefmt
              nixpkgs-fmt
            ];
            shellHook = ''
              export PS1='[$PWD]\n❄ '
            '';
          };
        });
    };
}
