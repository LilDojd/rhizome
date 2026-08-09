{ config, ... }:
let
  username = config.flake.meta.owner.username;
in
{
  flake = {
    modules.darwin.yawner = {
      users.users.${username}.home = "/Users/${username}";
      nix-homebrew.user = username;
      system.primaryUser = username;
    };

    modules.nixos.agenix.age.secrets.userPasswordHash = {
      rekeyFile = ./passwordHash.age;
      mode = "0400";
    };

    modules.nixos.yawner =
      { config, ... }:
      {
        nix.settings.trusted-users = [ username ];
        users.users.${username} = {
          isNormalUser = true;
          extraGroups = [
            "adbusers"
            "libvirtd"
            "lp"
            "scanner"
            "wheel"
            "dialout"
          ];
          hashedPasswordFile = config.age.secrets.userPasswordHash.path;
          home = "/home/${username}";
        };
      };
  };
}
