{
  config,
  inputs,
  ...
}:
{
  flake-file.inputs.streaming-flake = {
    url = "github:LilDojd/streaming-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  # TODO: Remove when Nixpkgs includes obs-composite-blur's upstream fix #138.
  nixpkgs.overlays = [
    (_final: prev: {
      obs-studio-plugins = prev.obs-studio-plugins // {
        obs-composite-blur = prev.obs-studio-plugins.obs-composite-blur.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace src/obs-utils.c \
              --replace-fail \
                "char *pos = strrchr(file_name, '/');" \
                "const char *pos = strrchr(file_name, '/');"
          '';
        });
      };
    })
  ];

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
