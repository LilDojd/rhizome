let
  selection = {
    dendriticSlop.extensions.pi-starship.enable = true;
  };
in
{
  flake.modules.nixos.slop = selection;
  flake.modules.darwin.slop = selection;
}
