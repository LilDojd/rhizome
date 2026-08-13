{ config, inputs, ... }:
{
  flake.modules.nixos."nixosConfigurations/darkforest" =
    {
      nixosModules,
      diskoConfigurations,
      ...
    }:
    {
      imports = with nixosModules; [
        foundation
        efi
        yawner
        nvidia-gpu
        mt7927
        inputs.dendritic-slop.modules.nixos.slop
        agenix
        diskoConfigurations.darkforest
      ];

      dendriticSlop = {
        enable = true;
        username = config.flake.meta.owner.username;
      };

      nixpkgs.hostPlatform = "x86_64-linux";
    };
}
