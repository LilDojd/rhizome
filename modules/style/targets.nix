_:
let
  polyModule = {
    stylix.autoEnable = true;
  };
in
{
  flake.modules = {
    nixos.foundation = polyModule;
    # darwin.foundation = polyModule;
    homeManager.gui = polyModule;
    homeManager.hyprland = polyModule;
  };
}
