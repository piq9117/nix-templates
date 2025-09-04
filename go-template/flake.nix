{
  description = "Basic go template";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    gomod2nix.url = github:nix-community/gomod2nix;
  };
  
  outputs = { self, nixpkgs, gomod2nix }:
    let
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      version = builtins.substring 0 8 lastModifiedDate;

      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
      });
    in
    {
      packages = forAllSystems(system: 
      let
        pkgs = nixpkgsFor.${system};
      in {
        default = pkgs.buildGoModule {
          inherit version;
          pname = "go-template";
          src = ./.;
          vendorHash = null;
        };
      });

      devShells = forAllSystems(system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              go
              gopls
              gotools
              go-tools
            ];
            shellHook = ''
              export PS1='[$PWD]\n❄ ';
              export GOPATH=$HOME/go
              export PATH=$GOPATH/bin:$PATH
              echo "Go version: $(go version)"
              echo "Development environment ready."
            '';
          };
        });
    };
}
