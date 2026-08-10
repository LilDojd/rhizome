{ config, ... }:
let
  username = config.flake.meta.owner.username;
  slop = config.flake.modules.homeManager.slop;
  systemModule = {
    home-manager.users.${username}.imports = [ slop ];
  };
in
{
  flake.modules.nixos.slop = systemModule;
  flake.modules.darwin.slop = systemModule;
}
