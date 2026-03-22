{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = lib.optionals (pkgs.stdenv.isLinux) [
        pkgs.bluetui
      ];
    };
}
