{ stdenv, cmake, fetchFromGitHub, lib }:

  stdenv.mkDerivation rec {
      name = "zug";
      version = "git-${commit}";
      commit = "deb266f4c7c35d325de7eb3d033f06e0809495f2";
      src = fetchFromGitHub {
        owner = "arximboldi";
        repo = "zug";
        rev = commit;
        sha256 = "0af6xv22y35zyky07h52bwb2dksqz138sr59kxbnnj7vwsiq5j5s";
      };
      nativeBuildInputs = [ cmake ];
      meta = with lib; {
        homepage = "http://sinusoid.es/zug";
        description = "Transducers for C++";
        license = licenses.boost;
      };
    }