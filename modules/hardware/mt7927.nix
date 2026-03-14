{ inputs, ... }:
{
  flake.modules.nixos.mt7927 = {
    imports = [ inputs.mt7927.nixosModules.default ];
    mt7927.enable = true;
  };
}
