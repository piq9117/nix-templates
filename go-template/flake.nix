{
  description = "go template";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  outputs = {self, nixpkgs}: 
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      nixpkgsFor = forAllSystems(system: import nixpkgs {
        inherit system;
      });
    in {
      devShells = forAllSystems(system: 
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              go
              gopls
              golangci-lint
              delve
            ];
          };
        });
    };
}
