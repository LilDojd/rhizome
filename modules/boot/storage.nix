{
  flake.modules.nixos.foundation = {
    boot.supportedFilesystems = [
      "btrfs"
      "vfat"
    ];
  };
}
