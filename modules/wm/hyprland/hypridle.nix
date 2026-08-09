{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    {
      config,
      pkgs,
      ...
    }:
    {
      services.hypridle = {
        enable = true;
        settings =
          let
            timeout = 300;
            loginctl = "${lib.getExe' pkgs.systemd "loginctl"}";
            hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
          in
          {
            general = {
              before_sleep_cmd = "${loginctl} lock-session";
              after_sleep_cmd = "${hyprctl} dispatch dpms on";
              ignore_dbus_inhibit = false;
            };

            listener = [
              {
                timeout = timeout - 10;
                on-timeout = "${loginctl} lock-session";
              }

              {
                inherit timeout;
                on-timeout = "${hyprctl} dispatch dpms off";
                on-resume = "${hyprctl} dispatch dpms on";
              }

              {
                timeout = timeout + 600;
                on-timeout = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
              }
            ];
          };
      };
      systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
    };
}
