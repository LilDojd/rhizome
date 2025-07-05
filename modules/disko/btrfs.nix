{
  disko.devices = {
    disk = {
      primary = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot0";
              name = "boot0";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
            swap = {
              label = "swap";
              name = "swap";
              size = "64G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
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
          "size=50%"
        ];
      };
    };
  };
}
