{ inputs, ... }:
{
  flake.modules = {
    nixos.foundation = {
      imports = [ "${inputs.nix-mineral}/nix-mineral.nix" ];
      nix-mineral.enable = true;
    };
  };
}
