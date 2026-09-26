{ inputs, ... }:
{
  flake.modules.homeManager.slop = {
    dendriticSlop.skills = {
      inherit (inputs.dendritic-slop.skills) frontend-design uncomplect;
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
