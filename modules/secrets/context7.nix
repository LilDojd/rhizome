{ config, ... }:
let
  secretFile = ./context7ApiKey.age;
  owner = config.flake.meta.owner.username;

  secretModule =
    { config, ... }:
    {
      age.secrets.context7ApiKey = {
        rekeyFile = secretFile;
        inherit owner;
        mode = "0400";
      };

      dendriticSlop.context7ApiKeyFile = config.age.secrets.context7ApiKey.path;
    };
in
{
  flake.modules.nixos.agenix = secretModule;
  flake.modules.darwin.agenix = secretModule;
}
