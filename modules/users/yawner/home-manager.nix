{ config, ... }:
{
  flake.modules.darwin.yawner = {
    home-manager = {
      extraSpecialArgs = {
        hasDifferentUsername = true;
      };

      users.${config.flake.meta.yawner.username} = {
        home = {
          inherit (config.flake.meta.yawner) username;
          stateVersion = "25.05";
          homeDirectory = "/Users/${config.flake.meta.yawner.username}";
        };
        imports = [
          config.flake.modules.homeManager.base
          config.flake.modules.homeManager.gui or { }
        ];
      };
    };
  };
}
