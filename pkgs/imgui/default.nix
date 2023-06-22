{ stdenv, fetchFromGitHub, lib }:

  stdenv.mkDerivation rec {
      name = "imgui-${version}";
      version = "git-${commit}";
      commit = "1ebb91382757777382b3629ced2a573996e46453";
      src = fetchFromGitHub {
        owner = "ocornut";
        repo = "imgui";
        rev = commit;
        sha256 = "0zz4pb61dvrdlb7cmlfqid7m8jc583cipspg9dyj39w16h4z9bhx";
      };
      buildPhase = "";
      installPhase = ''
        mkdir $out
        cp $src/*.h $out/
        cp $src/*.cpp $out/
        cp $src/backends/imgui_impl_* $out/
      '';
      meta = with lib; {
        description = "Immediate mode UI library";
        license = licenses.lgpl3;
      };
    }