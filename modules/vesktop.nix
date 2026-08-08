{ config, lib, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".config/discord"
      ".config/vesktop"
    ];
  flake.modules.homeManager.gui.programs.vesktop.enable = true;
  flake.modules.homeManager.hyprland = hmArgs: {
    wayland.windowManager.hyprland.settings.bind = [
      {
        _args = [
          (lib.generators.mkLuaInline ''modifier .. " + D"'')
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON (lib.getExe hmArgs.config.programs.vesktop.package)})")
        ];
      }
    ];
    wayland.windowManager.hyprland.settings.window_rule = lib.mkBefore [
      {
        match.class = "^([Vv]esktop)$";
        tag = "+im";
      }
    ];
  };
}
