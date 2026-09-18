{ config, ... }:
let
  secretFile = ./typesafeApiKey.age;
  owner = config.flake.meta.owner.username;

  secretModule =
    { config, ... }:
    let
      secretPath = config.age.secrets.typesafeApiKey.path;
    in
    {
      age.secrets.typesafeApiKey = {
        rekeyFile = secretFile;
        inherit owner;
        mode = "0400";
      };

      home-manager.users.${owner} =
        { config, lib, ... }:
        {
          programs.pi.coding-agent.environment =
            lib.mkIf (config.dendriticSlop.enable && config.dendriticSlop.extensions.jevons.enable)
              {
                TYPESAFE_API_KEY.file = secretPath;
              };
        };
    };
in
{
  flake.modules.nixos.agenix = secretModule;
  flake.modules.darwin.agenix = secretModule;
}
