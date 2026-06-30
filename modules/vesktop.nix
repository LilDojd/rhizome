{ config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".config/discord"
      ".config/vesktop"
    ];
  flake.modules.homeManager.gui.programs.vesktop.enable = true;
  nixpkgs.config.permittedInsecurePackages = [ "pnpm-10.29.2" ];
}
