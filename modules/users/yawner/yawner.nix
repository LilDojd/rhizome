{ config, ... }:
{
  flake = {
    meta.yawner.username = "yawner";

    modules.darwin.yawner = {
      nix.settings.trusted-users = [ config.flake.meta.yawner.username ];
      users.users.${config.flake.meta.yawner.username}.home =
        "/Users/${config.flake.meta.yawner.username}";
      nix-homebrew.user = config.flake.meta.yawner.username;
      system.primaryUser = config.flake.meta.yawner.username;
    };

    modules.nixos.yawner = {
      nix.settings.trusted-users = [ config.flake.meta.yawner.username ];
    };
  };

}
