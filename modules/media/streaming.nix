{
  inputs,
  lib,
  ...
}:
{
  flake.modules.homeManager.linux = {
    imports = [ inputs.streaming-flake.homeManagerModules.default ];
    programs.streaming-obs = {
      enable = true;
      twitchStreamKeyFile = "/run/agenix/twitchStreamKey";
    };
  };

  flake.modules.homeManager.hyprland = hmArgs: {
    wayland.windowManager.hyprland.settings.bind = [
      {
        _args = [
          (lib.generators.mkLuaInline ''modifier .. " + O"'')
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${lib.getExe hmArgs.config.programs.obs-studio.finalPackage} --profile Programming --collection Programming"})")
        ];
      }
    ];
  };
}
