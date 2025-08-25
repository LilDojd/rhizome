{
  disko.devices = {
    disk = {
      primary = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S69ENL0T913752F";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
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
              size = "64G";
              label = "disk-primary-swap";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
              size = "100%";
              label = "disk-primary-root";
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
      games = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WDS200T1X0E-00AFY0_22042R800806"; # nvme0n1
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              type = "8300";
              label = "disk-games";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "games"
                  "-f"
                ];
                subvolumes = {
                  "/games" = {
                    mountpoint = "/games";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "ssd"
                      "autodefrag"
                    ];
                  };
                };
              };
            };
          };
        };
      };

      backups = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD40NMZW-59A8NS1_WD-WXD2E205E3XW";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              type = "8300";
              label = "disk-backups";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "backups"
                  "-f"
                ];
                subvolumes = {
                  "/backups" = {
                    mountpoint = "/backups";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
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
