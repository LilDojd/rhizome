{ config, lib, ... }:
let
  secretFile = ./context7ApiKey.age;
  hasContext7ApiKey = builtins.pathExists secretFile;
  context7ApiKey = {
    rekeyFile = secretFile;
    owner = config.flake.meta.owner.username;
    mode = "0400";
  };
in
{
  flake.modules.nixos.agenix = lib.optionalAttrs hasContext7ApiKey {
    age.secrets.context7ApiKey = context7ApiKey;
  };
  flake.modules.darwin.agenix = lib.optionalAttrs hasContext7ApiKey {
    age.secrets.context7ApiKey = context7ApiKey;
  };

  flake.modules.homeManager.slop =
    { osConfig, ... }:
    {
      programs.pi.coding-agent.environment = lib.mkIf hasContext7ApiKey {
        CONTEXT7_API_KEY.file = osConfig.age.secrets.context7ApiKey.path;
      };

      xdg.configFile."mcp/mcp.json".text = builtins.toJSON {
        mcpServers.context7 = {
          url = "https://mcp.context7.com/mcp";
          lifecycle = "lazy";
        }
        // lib.optionalAttrs hasContext7ApiKey {
          headers.Authorization = "Bearer \${CONTEXT7_API_KEY}";
        };
      };
    };
}
