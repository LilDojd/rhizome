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
      lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        home.packages = [
          pkgs.libreoffice-stable
          pkgs.hunspell
        ]
        ++ dicts;
        home.sessionVariables.DICPATH = lib.concatMapStringsSep ":" (d: "${d}/share/hunspell") dicts;
      };
  };
}
