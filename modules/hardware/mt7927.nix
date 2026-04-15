{ inputs, ... }:
{
  flake.modules.nixos.mt7927 = {
    imports = [ inputs.mt7927.nixosModules.default ];
    hardware.mediatek-mt7927 = {
      enable = true;
      enableWifi = true;
      enableBluetooth = true;
      disableAspm = true;
    };
  };
}
