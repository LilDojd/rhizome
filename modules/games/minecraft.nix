{ config, inputs, ... }:
{
  flake-file.inputs.prismnix = {
    url = "github:qacow37/prismnix";
    inputs = {
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      imports = [ inputs.prismnix.homeModules.prismnix ];

      programs.prismnix = {
        enable = true;
        instances.vanilla = {
          minecraft = {
            enable = true;
            version = "26.3";
          };
          config.name = "Minecraft";
          instance.config = {
            OverrideJavaLocation.value = "true";
            JavaPath.value = "${pkgs.jdk25}/bin/java";
            OverrideMemory.value = "true";
            MinMemAlloc.value = "512";
            MaxMemAlloc.value = "8192";
          };
        };
      };
    };

  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [ ".local/share/PrismLauncher" ];
}
