{ config, ... }:
{
  flake.modules.nixos.foundation = {
    services.gnome.gnome-keyring.enable = true;
    environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];
  };
}
