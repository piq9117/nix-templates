{
  description = "Basic go template";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/23.11";

  outputs = { self, nixpkgs }:
    let
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      version = builtins.substring 0 8 lastModifiedDate;

      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linuxs" "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
    in
    {
      packages = forAllSystems(system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          basic-go-template = pkgs.buildGoModule {
            pname = "basic-go-template";
            inherit version;
            src = ./.;
            vendorSha256 = pkgs.lib.fakeSha256;
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
            shellHook = "export PS1='[$PWD]\n❄ '";
          };
        });
      defaultPackage = forAllSystems(system: self.packages.${system}.basic-go-template);
    };
}
