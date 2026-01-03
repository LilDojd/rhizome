{ ... }:
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
      ];
    };
}
