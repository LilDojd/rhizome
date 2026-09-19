let
  selection = {
    dendriticSlop.tools.firstmate.enable = true;
  };
in
{
  flake.modules.nixos.slop = selection;
  flake.modules.darwin.slop = selection;
}
