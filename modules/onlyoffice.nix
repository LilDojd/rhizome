{ config, ... }:
{
  flake.modules = {
    nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
      [
        ".config/onlyoffice"
        ".local/share/onlyoffice"
      ];
    homeManager.gui =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.onlyoffice-desktopeditors ];
      };
  };
}
