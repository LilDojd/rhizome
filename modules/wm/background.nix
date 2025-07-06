{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { config, ... }:

    let
      wpaperctl = lib.getExe' config.services.wpaperd.package "wpaperctl";
      submap = "background";
    in
    {
      wayland.windowManager.hyprland = {
        settings.misc.disable_hyprland_logo = true;

        extraConfig = ''
          submap = ${submap}
          binde = , n, exec, ${wpaperctl} next-wallpaper
          binde = , p, exec, ${wpaperctl} previous-wallpaper
          ${config.wayland.windowManager.hyprland.submapEnd}
          bind = $modifier, b, submap, ${submap}
        '';
      };

      services.wpaperd = {
        enable = true;
        settings.default = {
          path = "${config.home.homeDirectory}/backgrounds";
          duration = "4h";
          sorting = "random";
          queue-size = 20;
          mode = "center";
        };
      };
    };
}
