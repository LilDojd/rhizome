let
  selection = {
    dendriticSlop = {
      skills.typesafe-ai.enable = true;
      extensions.pi-typesafe.enable = true;
    };
  };
in
{
  flake.modules.nixos.slop = selection;
  flake.modules.darwin.slop = selection;
}
