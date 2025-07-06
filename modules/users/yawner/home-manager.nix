{ config, ... }:
{
  flake.modules.darwin.yawner =
    { pkgs, ... }:
    {
      home-manager = {
        extraSpecialArgs = {
          hasDifferentUsername = true;
        };

        users.${config.flake.meta.yawner.username} = {
          home = {
            inherit (config.flake.meta.yawner) username;
            stateVersion = "25.05";
            homeDirectory =
              if pkgs.stdenv.isDarwin then
                "/Users/${config.flake.meta.yawner.username}"
              else
                "/home/${config.flake.meta.yawner.username}";
          };
        };
      };
    };
}
