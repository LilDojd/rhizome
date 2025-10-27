{ lib, withSystem, ... }:
{
  flake.modules.homeManager.linux =
    {
      pkgs,
      config,
      ...
    }:
    let
      sink-rotate = withSystem pkgs.stdenv.hostPlatform.system ({ inputs', ... }: inputs'.sink-rotate.packages.default);
      mod = config.wayland.windowManager.sway.config.modifier;
    in
    {
      home.packages = [ sink-rotate ];
      wayland.windowManager = {
        sway.config.keybindings = {
          "--no-repeat ${mod}+c" = "exec ${lib.getExe sink-rotate}";
        };
        hyprland.settings.bind = [
          "SUPER, C, exec, ${lib.getExe sink-rotate}"
        ];
      };
    };
}
