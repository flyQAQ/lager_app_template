{ stdenv, fetchFromGitHub, cmake, boost, lib }:

  stdenv.mkDerivation rec {
      name = "immer-${version}";
      version = "git-${commit}";
      commit = "e5d79ed80ec74d511cc4f52fb68feeac66507f2c";
      src = fetchFromGitHub {
        owner = "arximboldi";
        repo = "immer";
        rev = commit;
        sha256 = "1h6m3hc26g15dhka6di6lphrl7wrgrxzn3nq0rfwg3iw10ifkw9f";
      };
      nativeBuildInputs = [ cmake ];
      buildInputs = [ boost ];
      meta = with lib; {
        homepage = "http://sinusoid.es/immer";
        description = "Immutable data structures for C++";
        license = licenses.lgpl3;
      };
    }