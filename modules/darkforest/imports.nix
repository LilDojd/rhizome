{ config, ... }: {
  flake.modules.nixos."nixosConfigurations/darkforest" = {
    imports = with config.flake.modules.nixos; [ pc efi yawner swap ];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
