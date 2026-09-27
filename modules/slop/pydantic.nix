{ inputs, ... }:
{
  flake.modules.homeManager.slop = {
    dendriticSlop.skills = inputs.dendritic-slop.skillSets.pydantic;

    programs.mcp.servers.logfire = {
      url = "https://logfire-us.pydantic.dev/mcp";
      auth = "oauth";
    };
  };
}
