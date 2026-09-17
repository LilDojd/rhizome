{ config, ... }:
let
  secretFile = ./typesafeApiKey.age;
  owner = config.flake.meta.owner.username;

  secretModule =
    { config, ... }:
    {
      age.secrets.typesafeApiKey = {
        rekeyFile = secretFile;
        inherit owner;
        mode = "0400";
      };

      dendriticSlop.extensions.pi-typesafe.secrets.apiKeyFile = config.age.secrets.typesafeApiKey.path;
    };
in
{
  flake.modules.nixos.agenix = secretModule;
  flake.modules.darwin.agenix = secretModule;
}
