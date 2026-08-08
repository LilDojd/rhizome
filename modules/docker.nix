{ config, ... }:
{
  flake.modules.nixos.foundation = {
    users.users.${config.flake.meta.owner.username}.extraGroups = [ "docker" ];
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
}
