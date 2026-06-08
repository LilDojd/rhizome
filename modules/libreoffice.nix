{ config, ... }:
{
  flake.modules = {
    nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
      [
        ".config/libreoffice"
      ];
    homeManager.gui =
      { pkgs, lib, ... }:
      let
        dicts = with pkgs.hunspellDicts; [ en_US ];
      in
      {
        home.packages = [
          pkgs.libreoffice-fresh
          pkgs.hunspell
        ]
        ++ dicts;
        home.sessionVariables.DICPATH = lib.concatMapStringsSep ":" (d: "${d}/share/hunspell") dicts;
      };
  };
}
