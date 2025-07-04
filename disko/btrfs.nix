{
  disko.devices = {
    disk = {
      primary = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            boot0 = {
              label = "boot0";
              name = "boot0";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot0";
                mountOptions = [
                  "defaults"
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
            swap0 = {
              label = "swap0";
              name = "swap0";
              size = "64G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
              label = "root";
              name = "root";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "storage"
                  "-f"
                ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" ];
                  };
                  "/persistent" = {
                    mountpoint = "/persistent";
                    mountOptions = [ "compress=zstd" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "noacl"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=4G"
        ];
      };
    };
  };
}
