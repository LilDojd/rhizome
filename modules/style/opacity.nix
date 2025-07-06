{ lib, ... }:
let
  polyModule = {
    stylix.opacity = (lib.genAttrs [ "applications" "desktop" "popups" ] (_: 0.85)) // {
      terminal = 0.95;
    };
  };
in
{
  flake.modules = {
    nixos.foundation = polyModule;
    # darwin.foundation = polyModule;
    homeManager.gui = polyModule;
  };
}
