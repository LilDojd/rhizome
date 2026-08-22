{
  config,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.agenix.age.secrets.twitchStreamKey = {
    rekeyFile = ./twitchStreamKey.age;
    owner = config.flake.meta.owner.username;
    mode = "0400";
  };

  flake.modules.homeManager.linux = {
    imports = [ inputs.streaming-flake.homeManagerModules.default ];
    programs.streaming-obs = {
      enable = true;
      profileName = "Programming";
      sceneCollectionName = "Programming";
      video = {
        baseWidth = 2560;
        baseHeight = 1440;
        outputWidth = 1920;
        outputHeight = 1080;
        fps = 60;
      };
      twitch = {
        enable = true;
        streamKeyFile = "/run/agenix/twitchStreamKey";
        channel = "yawnere";
        chat.enable = true;
      };
      scenes = {
        overwrite = false;
        backup = true;
      };
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
