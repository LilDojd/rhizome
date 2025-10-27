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
      nix.settings.extra-sandbox-paths = [ "/etc/nix/netrc" ];
      users.users.${config.flake.meta.yawner.username} = {
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
        home = "/home/${config.flake.meta.yawner.username}";
      };
    };
  };

}
