{
  config,
  inputs,
  ...
}:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".config/obs-studio"
    ];

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
      graphics.nvidiaOnly = true;
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
}
