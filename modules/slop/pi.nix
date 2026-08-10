{ inputs, config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [ ".pi/agent" ];

  flake.modules.homeManager.slop = {
    imports = [ inputs.pi.homeModules.default ];

    programs.pi.coding-agent = {
      enable = true;
      rules = ./rules.md;

      skills = [ (inputs.herdr + "/skills/herdr") ];
      extensions = [ (inputs.herdr + "/src/integration/assets/pi/herdr-agent-state.ts") ];

      settings.packages = [ "npm:pi-mcp-adapter@2.21.2" ];
    };
  };
}
