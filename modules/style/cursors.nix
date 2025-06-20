{ lib, ... }:
let
  polyModule =
    polyArgs@{ pkgs, ... }:
    {
      stylix = lib.mkDefault {
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 24;
        };
      };
    };
in
{
  flake.modules = {
    nixos.pc = polyModule;
    homeManager.base = polyModule;
  };
}
