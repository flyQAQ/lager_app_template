{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/f904e3562aabca382d12f8471ca2330b3f82899a";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ self.overlays.default ];
      };

    in {
      overlays.default = final: prev: {
        cereal = final.callPackage ./pkgs/cereal {};
        immer  = final.callPackage ./pkgs/immer {};
        imgui  = final.callPackage ./pkgs/imgui {};
        lager  = final.callPackage ./pkgs/lager {};
        zug    = final.callPackage ./pkgs/zug {};
      };

      devShells.x86_64-linux = rec {
        rprofile = pkgs.mkShell {
          buildInputs = [
            pkgs.stdenv.cc
            pkgs.cmake
            pkgs.SDL2
            pkgs.SDL2_ttf
            pkgs.boost
            pkgs.imgui
            pkgs.immer
            pkgs.lager
            pkgs.cereal
            pkgs.zug
          ];

          shellHook = ''
            export DIR_ROOT=`dirname ${toString ./flake.nix}`
            export PATH=$PATH:"$DIR_ROOT/build"
            export IMGUI_SOURCE_DIR=${pkgs.imgui}
          '';
        };

        default = rprofile;
      };

      packages.x86_64-linux = rec {
        rprofile = pkgs.stdenv.mkDerivation {

        };

        default = rprofile;
      };
    };
}
