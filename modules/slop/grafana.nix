{ inputs, ... }:
{
  flake.modules.homeManager.slop =
    { lib, pkgs, ... }:
    {
      programs.mcp.servers.grafana = {
        command = lib.getExe inputs.dendritic-slop.packages.${pkgs.stdenv.hostPlatform.system}.mcp-grafana;
        args = [ "--disable-write" ];
      };
    };
}
