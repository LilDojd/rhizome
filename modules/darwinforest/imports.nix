{ config, ... }:
{
  flake.modules.darwin."darwinConfigurations/darwinforest" = {
    imports = with config.flake.modules.darwin; [
      foundation
      yawner
    ];
    nixpkgs.hostPlatform = "aarch64-darwin";
    system.stateVersion = 6;
  };
}
