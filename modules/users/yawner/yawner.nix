{ config, ... }:
{
  flake = {
    modules.darwin.yawner = {
      users.users.${config.flake.meta.owner.username}.home =
        "/Users/${config.flake.meta.owner.username}";
      nix-homebrew.user = config.flake.meta.owner.username;
      system.primaryUser = config.flake.meta.owner.username;
    };

    modules.nixos.yawner = {
      nix.settings.trusted-users = [ config.flake.meta.owner.username ];
      users.users.${config.flake.meta.owner.username} = {
        isNormalUser = true;
        extraGroups = [
          "adbusers"
          "docker"
          "libvirtd"
          "lp"
          "networkmanager"
          "scanner"
          "wheel"
          "dialout"
        ];
        hashedPassword = "$y$j9T$vrOwuuW6ZjyNV8U27M8Ik.$0nmFU60b0l4sQ.kRlTv71pwaZAFMJbyGnvnWvSWu/F6";
        home = "/home/${config.flake.meta.owner.username}";
      };
    };
  };

}
