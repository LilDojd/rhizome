{ config, ... }:
{
  flake.modules.nixos."nixosConfigurations/darkforest" = {
    imports = with config.flake.modules.nixos; [
      pc
      yawner
    ];
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = 25.05;
  };
}
