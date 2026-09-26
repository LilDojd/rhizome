{ inputs, ... }:
{
  flake.modules.homeManager.slop =
    { lib, pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      packages = inputs.dendritic-slop.packages.${system};
    in
    {
      dendriticSlop.piPackages = [
        packages.pi-playwright
        packages.pi-web-access
      ];
      programs.mcp.servers.agent-browser = {
        command = lib.getExe' inputs.llm-agents.packages.${system}.agent-browser "agent-browser";
        args = [ "mcp" ];
      };
    };
}
