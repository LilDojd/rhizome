{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.hyprpicker ];
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            (lib.generators.mkLuaInline ''modifier .. " + C"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${lib.getExe pkgs.hyprpicker} -a"})")
          ];
        }
      ];
    };
}
