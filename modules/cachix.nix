{ lib, ... }:
{
  flake.modules.homeManager.base =
    homeArgs@{ pkgs, ... }:
    {
      home.packages = [ pkgs.cachix ];
    };
}
