{ inputs, ... }:
{
  flake.modules.homeManager.slop =
    { pkgs, ... }:
    {
      dendriticSlop = {
        skills = inputs.dendritic-slop.skillSets.core;
        piPackages = [ inputs.dendritic-slop.packages.${pkgs.stdenv.hostPlatform.system}.pi-ask-user ];
      };

      programs.pi.coding-agent = {
        enable = true;
        environment.PI_ASK_USER_DISPLAY_MODE.value = "inline";
      };

      programs.mcp.enable = true;

      programs.git.ignores = [
        ".mcp.json"
        "mcp.json"
      ];
    };
}
