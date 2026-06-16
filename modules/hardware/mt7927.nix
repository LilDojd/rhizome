{ inputs, ... }:
{
  flake.modules.nixos.mt7927 =
    { pkgs, ... }:
    {
      imports = [ inputs.mt7927.nixosModules.default ];
      hardware.mediatek-mt7927 = {
        enable = true;
        enableWifi = true;
        enableBluetooth = true;
        disableAspm = true;
      };

      # Workaround for cmspam/mt7927-nixos#4: the patched btmtk probes
      # mediatek/mt7927/BT_RAM_CODE_MT6639_2_1_hdr.bin, but the flake installs
      # the Bluetooth blob under mediatek/mt6639/. Re-expose the same blob at
      # the mt7927 path the kernel actually requests.
      hardware.firmware = [
        (pkgs.runCommand "mt7927-bt-firmware-pathfix" { } ''
          install -Dm644 \
            ${
              inputs.mt7927.packages.${pkgs.stdenv.hostPlatform.system}.firmware
            }/lib/firmware/mediatek/mt6639/BT_RAM_CODE_MT6639_2_1_hdr.bin \
            $out/lib/firmware/mediatek/mt7927/BT_RAM_CODE_MT6639_2_1_hdr.bin
        '')
      ];
    };
}
