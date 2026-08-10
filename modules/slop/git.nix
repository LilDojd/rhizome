{ ... }:
{
  flake.modules.homeManager.slop.programs.git.ignores = [
    ".mcp.json"
    "mcp.json"
  ];
}
