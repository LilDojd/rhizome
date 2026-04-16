{ config, ... }:
{
  flake.modules.nixos.foundation = {
    environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
      ".local/share/Larian Studios"
    ];
  };
}
