{ config, ... }:
{
  flake.modules.darwin."darwinConfigurations/darwinforest" = {
    imports = with config.flake.modules.darwin; [
      foundation
      yawner
    ];
  };
}
