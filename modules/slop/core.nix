let
  profile = {
    dendriticSlop.profiles.core.enable = true;
  };
in
{
  flake.modules.nixos.slop = profile;
  flake.modules.darwin.slop = profile;
}
