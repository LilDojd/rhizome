{ config, inputs, ... }:
{
  flake.modules.darwin."darwinConfigurations/darwinforest" =
    {
      darwinModules,
      ...
    }:
    {
      imports = with darwinModules; [
        foundation
        yawner
        agenix
        inputs.dendritic-slop.modules.darwin.slop
      ];

      dendriticSlop = {
        enable = true;
        username = config.flake.meta.owner.username;
      };
    };
}
