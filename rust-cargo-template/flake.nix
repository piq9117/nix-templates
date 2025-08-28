{
  description = "Basic Rust Cargo Template";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };

  outputs = { self, nixpkgs }: 
    let
      supportedSystems = ["x86_64-linux"];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems(system: import nixpkgs {
        inherit system;
      });
    in {

      # Initialize project with cargo init
      # 
      # Uncomment after initiating project
      #
      # packages = forAllSystems(system: 
      #   let
      #     pkgs = nixpkgsFor.${system};
      #   in { 
      #     default = pkgs.rustPlatform.buildRustPackage {
      #       pname = "";
      #       version = "0.0.0";
      #       src = ./.;
      #       cargoLock = {
      #         lockFile = ./Cargo.lock;
      #       };
      #     };
      #   });

      devShells = forAllSystems(system: 
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              rustc
              cargo
              rust-analyzer
              rustfmt
              treefmt
            ];
            shellHook = ''
              export PS1='[$PWD]\n❄ '
            '';
          };
        });
    };
}
