{ config, ... }:
{
  flake.modules.darwin.yawner =
    { pkgs, ... }:
    {
      home-manager = {
        extraSpecialArgs = {
          hasDifferentUsername = true;
        };

        users.${config.flake.meta.owner.username} = {
          home = {
            inherit (config.flake.meta.owner) username;
            stateVersion = "25.11";
            homeDirectory =
              if pkgs.stdenv.isDarwin then
                "/Users/${config.flake.meta.owner.username}"
              else
                "/home/${config.flake.meta.owner.username}";
          };
        };
      };
    };
}
