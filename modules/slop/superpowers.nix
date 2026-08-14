let
  profile = {
    dendriticSlop.profiles.superpowers.enable = false;
  };
in
{
  flake.modules.nixos.slop = profile;
  flake.modules.darwin.slop = profile;
}
