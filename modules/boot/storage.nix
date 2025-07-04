{ lib, ... }:
{
  flake.modules.nixos.pc = nixosArgs: {
    boot.loader.grub.mirroredBoots =
      nixosArgs.config.storage.redundancy.range
      |> map (i: [
        {
          devices = [ "nodev" ];
          path = "/boot${i}";
        }
      ])
      |> lib.mkMerge;

    fileSystems =
      nixosArgs.config.storage.redundancy.range
      |> map (i: {
        "/boot${i}" = {
          device = "/dev/disk/by-partlabel/boot${i}";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };
      })
      |> lib.mkMerge;
  };
}
