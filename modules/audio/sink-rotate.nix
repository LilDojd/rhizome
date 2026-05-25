{ lib, ... }:
{
  flake.modules.homeManager.linux =
    {
      pkgs,
      config,
      ...
    }:
    let
      mod = config.wayland.windowManager.sway.config.modifier;
    in
    {
      home.packages = [ pkgs.sink-rotate ];
      wayland.windowManager = {
        sway.config.keybindings = {
          "--no-repeat ${mod}+c" = "exec ${lib.getExe pkgs.sink-rotate}";
        };
        hyprland.settings.bind = [
          {
            _args = [
              "SUPER + C"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON (lib.getExe pkgs.sink-rotate)})")
            ];
          }
        ];
      };
    };
}
