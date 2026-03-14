{ ... }:
{
  flake.modules.nixos."nixosConfigurations/darkforest" =
    {
      nixosModules,
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
        ./_disko.nix
      ];
      nixpkgs.hostPlatform = "x86_64-linux";
    };
}
