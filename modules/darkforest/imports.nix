{ config, ... }:
{
  flake.modules.nixos."nixosConfigurations/darkforest" = {
    imports = with config.flake.modules.nixos; [
      pc
      efi
      yawner
      nvidia-gpu
      ./_disko.nix
    ];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
