{ stdenv, cmake, fetchFromGitHub, lib }:

  stdenv.mkDerivation rec {
      name = "cereal-${version}";
      version = "git-arximboldi-${commit}";
      commit = "2fe15c57f813db1b14c9b5e3e2389f7c5d1c5aff";
      src = fetchFromGitHub {
        owner = "flyqaq";
        repo = "cereal";
        rev = commit;
        sha256 = "119sldlzkrpnbb0kg052b851kifc7hwnc5vik1fdklramx5gzy97";
      };
      nativeBuildInputs = [ cmake ];
      cmakeFlags = [ "-DJUST_INSTALL_CEREAL=true" ];
      meta = with lib; {
        homepage = "http://uscilab.github.io/cereal";
        description = "A C++11 library for serialization";
        license = licenses.bsd3;
      };
    }