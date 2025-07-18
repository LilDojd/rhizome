{ lib, ... }:
let
  polyModule =
    polyArgs@{ pkgs, ... }:
    {
      stylix.fonts = {
        sansSerif = lib.mkDefault {
          package = pkgs.montserrat;
          name = "Montserrat";
        };

        serif = lib.mkDefault polyArgs.config.stylix.fonts.sansSerif;

        monospace = {
          package = pkgs.maple-mono.NF-unhinted;
          name = "Maple Mono NF";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = 12;
          desktop = 11;
          popups = 12;
          terminal = 15;
        };
      };

      fonts.fontconfig.enable = true;
    };
in
{
  flake.modules = {
    nixos.foundation =
      { pkgs, ... }:
      {
        imports = [ polyModule ];
        fonts.packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ];
      };

    homeManager.gui = {
      imports = [ polyModule ];
    };

  };
}
