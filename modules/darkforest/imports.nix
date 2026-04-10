{ ... }:
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
        agenix
        diskoConfigurations.darkforest
      ];
      nixpkgs.hostPlatform = "x86_64-linux";
    };
}
