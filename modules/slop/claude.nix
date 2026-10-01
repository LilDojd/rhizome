{ inputs, ... }:
{
  flake.modules.homeManager.slop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      dendriticSlop.skills = {
        inherit (inputs.dendritic-slop.skills) frontend-design uncomplect;
      };

      dendriticSlop.piPackages = [
        inputs.dendritic-slop.packages.${pkgs.stdenv.hostPlatform.system}.pi-claude-bridge
      ];
      home.file.".pi/agent/claude-bridge.json".source =
        (pkgs.formats.json { }).generate "claude-bridge.json"
          {
            askClaude.enabled = false;
            provider = {
              plan = "max";
              pathToClaudeCodeExecutable = lib.getExe config.programs.claude-code.package;
            };
          };

      programs.claude-code = {
        enable = true;
        settings = {
          skipDangerousModePermissionPrompt = true;
          attribution = {
            commit = "";
            pr = "";
            sessionUrl = false;
          };
        };
        lspServers.rust-analyzer = {
          command = "rust-analyzer";
          extensionToLanguage.".rs" = "rust";
        };
      };
    };
}
