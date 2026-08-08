{
  flake.modules.nixos.foundation = {
    services.btrfs.autoScrub.enable = true;
    services.btrfs.autoScrub.interval = "weekly";
    services.btrfs.autoScrub.fileSystems = [ "/" ];
  };
}
