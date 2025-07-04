{
  lib,
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.pc = {
    imports = [ inputs.disko.nixosModules.disko ];

    config = lib.mkMerge [
      (import "${self}/disko/partition.nix" {
        ssd = false;
        ssdOptions = [ ];
        inherit lib;
        impermanence = true;
        ecnrypted = false;
      })
    ];
  };
}
