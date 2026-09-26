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

      home-manager.users.${owner}.programs.pi.coding-agent.environment.TYPESAFE_API_KEY.file =
        config.age.secrets.typesafeApiKey.path;
    };
in
{
  flake.modules.nixos.agenix = secretModule;
  flake.modules.darwin.agenix = secretModule;
}
