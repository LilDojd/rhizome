let
  profile = {
    dendriticSlop.profiles.web.enable = true;
  };
in
{
  flake.modules.nixos.slop = profile;
  flake.modules.darwin.slop = profile;
}
