{
  description = "Basic purescript flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/23.05";
  inputs.purescript-overlay.url = "github:thomashoneyman/purescript-overlay";
  inputs.purescript-overlay.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, purescript-overlay }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      nixpkgsFor = forAllSystems(system: import nixpkgs {
        inherit system;
        overlays = [ self.overlay purescript-overlay.overlays.default ];
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
              purs
              spago
              purs-tidy-bin.purs-tidy-0_10_0
              purs-backend-es
              treefmt
              nixpkgs-fmt
              nodejs
            ];
            shellHook = "export PS1='[$PWD]\n❄ '";
          };
        });
    };
}
