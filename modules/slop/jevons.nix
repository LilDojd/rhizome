let
  selection = {
    dendriticSlop.extensions.jevons.enable = true;
  };
in
{
  flake.modules.nixos.slop = selection;
  flake.modules.darwin.slop = selection;
}
