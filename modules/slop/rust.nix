let
  profile = {
    dendriticSlop.profiles.rust.enable = true;
  };
in
{
  flake.modules.nixos.slop = profile;
  flake.modules.darwin.slop = profile;
}
