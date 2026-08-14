let
  profile = {
    dendriticSlop.profiles.python.enable = false;
  };
in
{
  flake.modules.nixos.slop = profile;
  flake.modules.darwin.slop = profile;
}
