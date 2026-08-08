{ config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      {
        directory = ".gnupg";
        mode = "0700";
      }
    ];
  flake.modules.homeManager.base.programs.gpg.enable = true;
}
