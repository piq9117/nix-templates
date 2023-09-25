{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/23.05";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [self.overlay];
      });
    in
    {
      overlay = self: super: {};
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              dune_3
              ocamlPackages.ocaml
              ocamlPackages.lwt
              ocamlPackages.findlib
              ocamlformat
              treefmt
            ];
            shellHook = "export PS1='[$PWD]\n❄ '";
          };
        });
    };
}
