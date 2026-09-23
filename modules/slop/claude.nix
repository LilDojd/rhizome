let
  selection = {
    dendriticSlop = {
      targets.claude.enable = true;
      skills = {
        frontend-design.enable = true;
        uncomplect.enable = true;
      };
    };
  };
in
{
  flake.modules.nixos.slop = selection;
  flake.modules.darwin.slop = selection;

  flake.modules.homeManager.base.programs.claude-code = {
    settings = {
      model = "opus[1m]";
      effortLevel = "xhigh";
      skipDangerousModePermissionPrompt = true;
    };
    lspServers.rust-analyzer = {
      command = "rust-analyzer";
      extensionToLanguage.".rs" = "rust";
    };
  };
}
