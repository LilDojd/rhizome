{
  flake.modules.nixos.pc = {
    boot.supportedFilesystems = [
      "btrfs"
      "vfat"
    ];
  };
}
