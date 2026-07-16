{ config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".config/discord"
      ".config/vesktop"
    ];
  flake.modules.homeManager.gui.programs.vesktop.enable = true;
  # TODO: remove electron-40.10.5 after https://github.com/NixOS/nixpkgs/issues/542512 resolved
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
    "electron-40.10.5"
  ];
}
