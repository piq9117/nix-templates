{
  description = "Flutter template";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  };

  outputs = {self, nixpkgs}: 
  let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    nixpkgsFor = forAllSystems(system: import nixpkgs {
      inherit system;
      overlays = [self.overlays];
      config = {
        android_sdk.accept_license = true;
        allowUnfree = true;
      };
    });
  
  in {
    overlays = final: prev: {};
    devShells = forAllSystems(system: 
      let
        pkgs = nixpkgsFor.${system};
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          platformVersions = ["34" "28"];
          abiVersions = ["armeabi-v7a" "arm64-v8a"];
        };
        androidSdk = androidComposition.androidsdk;
      in {
        default = pkgs.mkShell rec {
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          buildInputs = with pkgs; [
            flutter
            androidSdk
            jdk17
            nixpkgs-fmt
            treefmt
          ];
          shellHook = ''
            export PS1='[$PWD]\n❄ '
          '';
        };
      });
  };
}
