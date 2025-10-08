{
  flake.modules = {
    homeManager.gui =
      { pkgs, ... }:
      let
        python = pkgs.python311;
        pythonPackages = python.pkgs;

        pymolFixed = pkgs.callPackage ./_pymol.nix {
          inherit (pkgs)
            stdenv
            lib
            fetchFromGitHub
            makeDesktopItem
            cmake
            netcdf
            glew
            glm
            libpng
            libxml2
            freetype
            mmtf-cpp
            msgpack-cxx
            qt5
            ;
          python3Packages = pythonPackages;
        };
      in
      {
        home.packages = [
          pymolFixed
        ];
      };
  };
}
