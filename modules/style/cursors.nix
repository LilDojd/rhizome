{ lib, ... }:
let
  polyModule =
    { pkgs, ... }:
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
    # darwin.pc = polyModule;
    homeManager.gui = polyModule;
  };
}
