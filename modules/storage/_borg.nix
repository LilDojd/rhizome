{
  flake.modules.nixos.foundation = {

    systemd.tmpfiles.rules = [
      "d /mnt/backups/borg 0750 root root -"
    ];

    services.borgbackup.jobs = {
      # Local backup job
      local = {
        enable = true;
        paths = [
          "/etc"
          "/home/yawner"
          "/persistent"
        ];
        exclude = [
          "**/.cache"
          "/nix"
          "/home/yawner/.local/share/Steam"
        ];
        repo = "/mnt/backups/borg";
        encryption = {
          mode = "repokey-blake2";
          passphrase = "FILE:/etc/borg/passphrase-local"; # create once, mode 600
        };
        compression = "auto,zstd";
        prune.keep = {
          within = "7d";
          daily = 14;
          weekly = 8;
          monthly = 12;
        };
        startAt = "daily";
        extraOptions = [ "--stats" ];
      };

      # Remote backup to BorgBase
      borgbase = {
        enable = true;
        paths = [
          "/etc"
          "/home/yawner"
          "/persistent"
        ];
        exclude = [
          "**/.cache"
          "/nix"
          "/home/yawner/.local/share/Steam"
        ];
        repo = "o6h6zl22@o6h6zl22.repo.borgbase.com:repo"; # replace with your repo path
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /root/borgbackup/passphrase"; # matches your guide
        };
        environment = {
          BORG_RSH = "ssh -i /root/borgbackup/ssh_key";
        };
        compression = "auto,lzma"; # you can keep lzma for remote
        prune.keep = {
          within = "7d";
          daily = 14;
          weekly = 8;
          monthly = 12;
        };
        startAt = "daily";
        extraOptions = [ "--stats" ];
      };
    };

    systemd.services."borgbackup-job-local".after = [ "mnt-backups.mount" ];
    systemd.services."borgbackup-job-local".requires = [ "mnt-backups.mount" ];
  };
}
