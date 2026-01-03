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
        agenix
        ./_disko.nix
      ];
      nixpkgs.hostPlatform = "x86_64-linux";
    };
}
