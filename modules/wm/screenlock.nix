{ lib, ... }:
{
  flake.modules = {
    nixos.pc.security.pam.services.swaylock = { };

    homeManager.gui =
      hmArgs@{ pkgs, ... }:
      lib.mkIf pkgs.stdenv.isLinux {
        programs.hyprlock = {
          enable = true;
          settings = {
            general = {
              disable_loading_bar = true;
              grace = 10;
              hide_cursor = true;
              no_fade_in = false;
            };
            background = lib.mkForce [
              {
                path = "/home/${hmArgs.config.home.homeDirectory}/backgrounds/beautifulmountainscape.jpg";
                blur_passes = 3;
                blur_size = 8;
              }
            ];
            image = [
              {
                path = "/home/${hmArgs.config.home.homeDirectory}/.config/hero.jpg";
                size = 150;
                border_size = 4;
                border_color = "rgb(0C96F9)";
                rounding = -1;
                position = "0, 200";
                halign = "center";
                valign = "center";
              }
            ];
            input-field = lib.mkForce [
              {
                size = "200, 50";
                position = "0, -80";
                monitor = "";
                dots_center = true;
                fade_on_empty = false;
                font_color = "rgb(CFE6F4)";
                inner_color = "rgb(657DC2)";
                outer_color = "rgb(0D0E15)";
                outline_thickness = 5;
                placeholder_text = "Password...";
                shadow_passes = 2;
              }
            ];
          };
        };
      };
  };
}
