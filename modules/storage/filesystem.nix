{
  flake.modules.nixos.pc = {
    boot.zfs.forceImportRoot = false;
    services.btrfs.autoScrub.enable = true;
    services.btrfs.autoScrub.interval = "weekly";
    services.btrfs.autoScrub.fileSystems = [ "/" ];

  };
}
