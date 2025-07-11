{ lib, ... }:
let
  polyModule =
    { pkgs, ... }:
    {
      stylix.cursor = lib.mkDefault {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };

in
{
  flake.modules = {
    nixos.foundation = polyModule;
    homeManager.gui = polyModule;
  };
}
