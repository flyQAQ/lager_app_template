{ stdenv, cmake, fetchFromGitHub, boost, ncurses, gcc7, sass, lib, immer, cereal, zug }:

  stdenv.mkDerivation rec {
      name = "lager";
      version = "git-${commit}";
      commit = "0f311b5a99fd24fb559ff2d615facdfb44523ee1";
      src = fetchFromGitHub {
        owner = "flyqaq";
        repo = "lager";
        rev = commit;
        sha256 = "1khjfph0kw17jla8d7lfz5syplssv15f6ijz33m62v3l3a53qnhn";
      };
      buildInputs = [
        ncurses
      ];
      nativeBuildInputs = [
        cmake
        gcc7
        sass
      ];
      propagatedBuildInputs = [
        boost
        immer
        zug
        cereal
      ];
      cmakeFlags = [ "-Dlager_BUILD_TESTS=OFF" "-Dlager_BUILD_FAILURE_TESTS=OFF" ];
      meta = with lib; {
        homepage    = "https://github.com/arximboldi/lager";
        description = "library for functional interactive c++ programs";
        license     = licenses.lgpl3Plus;
      };
    }
