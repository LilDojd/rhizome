{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gimp ];
      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            (lib.generators.mkLuaInline ''modifier .. " + G"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON (lib.getExe pkgs.gimp)})")
          ];
        }
      ];
    };
}
