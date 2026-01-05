{
  flake.modules.nixos.foundation = {
    services.btrbk.instances.persistent = {
      onCalendar = "daily";
      settings = {
        timestamp_format = "long";
        snapshot_preserve_min = "1w";
        snapshot_preserve = "2w";
        volume."/persistent" = {
          snapshot_dir = "/snapshots";
          subvolume."." = { };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /snapshots 0755 root root"
    ];
  };
}
