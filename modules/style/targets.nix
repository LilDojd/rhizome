_:
let
  polyModule = {
    stylix.autoEnable = true;
  };
in
{
  flake.modules = {
    nixos.pc = polyModule;
    # darwin.pc = polyModule;
    homeManager.gui = polyModule;
  };
}
