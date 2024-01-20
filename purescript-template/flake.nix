{
  description = "Basic purescript flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    purescript-overlay = {
      url = "github:thomashoneyman/purescript-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    easy-purescript-nix.url = "github:justinwoo/easy-purescript-nix";
  };

  outputs = { self, nixpkgs, purescript-overlay, easy-purescript-nix }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      nixpkgsFor = forAllSystems(system: import nixpkgs {
        inherit system;
        overlays = [ self.overlay purescript-overlay.overlays.default ];
      });
    in
    {
      overlay = final: prev: {};
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          easy-ps = easy-purescript-nix.packages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              easy-ps.purs-0_15_8
              easy-ps.spago
              easy-ps.purescript-language-server
              easy-ps.purs-tidy
              pkgs.nodejs-18_x
              pkgs.esbuild
            ];
            shellHook = ''
              export PS1='[$PWD]\n❄ '

              source <(spago --bash-completion-script `which spago`)
              source <(node --completion-bash)
            '';
          };
        });
    };
}
