{ config, ... }:
let
  secretFile = ./context7ApiKey.age;
  owner = config.flake.meta.owner.username;

  secretModule =
    { config, ... }:
    let
      secretPath = config.age.secrets.context7ApiKey.path;
    in
    {
      age.secrets.context7ApiKey = {
        rekeyFile = secretFile;
        inherit owner;
        mode = "0400";
      };

      home-manager.users.${owner} = {
        programs.mcp.servers.context7 = {
          url = "https://mcp.context7.com/mcp";
          headers.Authorization = "Bearer \${CONTEXT7_API_KEY}";
        };
        dendriticSlop.mcpHeaderSecrets.context7.CONTEXT7_API_KEY = secretPath;
      };
    };
in
{
  flake.modules.nixos.agenix = secretModule;
  flake.modules.darwin.agenix = secretModule;
}
