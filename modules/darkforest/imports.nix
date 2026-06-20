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
        # TODO: re-enable once cmspam/mt7927-nixos mt76 builds on kernel 7.1
        # mt7927
        agenix
        diskoConfigurations.darkforest
      ];
      nixpkgs.hostPlatform = "x86_64-linux";
    };
}
