{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    let
      brightnessctl = lib.getExe pkgs.brightnessctl;
      exec =
        command:
        lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${brightnessctl} ${command}"})";
    in
    {
      home.packages = [ pkgs.brightnessctl ];

      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "XF86MonBrightnessDown"
            (exec "set 5%-")
          ];
        }
        {
          _args = [
            "XF86MonBrightnessUp"
            (exec "set +5%")
          ];
        }
      ];
    };
}
