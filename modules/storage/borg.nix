{
  lib,
  config,
  ...
}:
{
  flake.modules.nixos.foundation =
    nixosArgs@{ pkgs, ... }:
    let
      inherit (lib)
        mkMerge
        mapAttrs'
        mkBefore
        nameValuePair
        isString
        flip
        mkIf
        ;

      persist = nixosArgs.config.environment.persistence."/persistent" or { };
      userName = config.flake.meta.owner.username;
      userUid = toString (nixosArgs.config.users.users.${userName}.uid or 1000);
      userPersist = (
        persist.users.${userName} or {
          directories = [ ];
          files = [ ];
        }
      );
      userDirsRaw = userPersist.directories;
      userFilesRaw = userPersist.files;

      normDir =
        v: if isString v then v else (v.directory or (throw "impermanence: directory attr missing"));
      userDirs = map normDir userDirsRaw;
      userFiles = map (
        v: if isString v then v else (v.path or v.file or (throw "impermanence: file path missing"))
      ) userFilesRaw;

      toHome = p: "/home/${userName}/${p}";
      pathsCommon = [
        "/etc/nixos"
        "/var/lib"
      ]
      ++ (map toHome userDirs)
      ++ (map toHome userFiles);

      excludesCommon = [
        "**/.cache"
        "/nix"
        "/var/lib/docker"
        "/var/lib/systemd"
        "/var/lib/libvirt"
        "**/target"
        "/home/*/go/bin"
        "/home/*/go/pkg"
        "*/Cache"
        ".config/Slack/logs"
        ".config/Code/CachedData"
        ".container-diff"
        ".npm/_cacache"
        "*/node_modules"
        "*/bower_components"
        "*/_build"
        "*/.tox"
        "*/venv"
        "*/.venv"
        "**/1Password"
      ];

      pruneKeep = {
        within = "7d";
        daily = 14;
        weekly = 8;
        monthly = 12;
      };

      mkBackupJob = name: extra: {
        services.borgbackup.jobs.${name} = {
          paths = pathsCommon;
          exclude = excludesCommon;
          compression = extra.compression or "auto,zstd";
          prune.keep = pruneKeep;
          startAt = extra.startAt or "daily";
          extraCreateArgs = [ "--stats" ] ++ (extra.extraCreateArgs or [ ]);
          # Per-job fields:
          repo = extra.repo;
          encryption = extra.encryption;
          environment = extra.environment or { };
          extraInitArgs = extra.extraInitArgs or "";
          persistentTimer = true;
          user = extra.user or "root";
        };

        systemd.services."borgbackup-job-${name}".unitConfig.OnFailure = [ "notify-problems@%i.service" ];
      };

    in
    mkMerge [
      {
        systemd.tmpfiles.rules = [
          "d /backups/borg 0750 root root -"
        ];
        age.secrets.borgPassphrase = {
          generator.script = "passphrase";
          rekeyFile = ./borgPassphrase.age;
        };
      }

      # Local job (waits for /backups to be mounted)
      (mkBackupJob "local" {
        repo = "/backups/borg";
        startAt = "weekly";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat ${nixosArgs.config.age.secrets.borgPassphrase.path}";
        };
        compression = "auto,zstd";
      })

      {
        systemd.services."borgbackup-job-local".after = [ "backups.mount" ];
        systemd.services."borgbackup-job-local".requires = [ "backups.mount" ];
      }

      (mkBackupJob "borgbase" {
        repo = "m8yoakd9@m8yoakd9.repo.borgbase.com:repo";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat ${nixosArgs.config.age.secrets.borgPassphrase.path}";
        };
        environment = {
          BORG_RSH = "ssh -i /root/borgbackup/ssh_key";
        };
        compression = "auto,lzma";
      })

      {
        systemd.services = {
          "notify-problems@" = {
            enable = true;
            serviceConfig = {
              Type = "simple";
              User = userName;
              Environment = [
                "XDG_RUNTIME_DIR=/run/user/${userUid}"
                "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${userUid}/bus"
              ];
            };
            environment.SERVICE = "%i";
            script = ''
              ${pkgs.libnotify}/bin/notify-send -t 5000 -u critical "$SERVICE FAILED!" \
                "Run: journalctl -u $SERVICE"
            '';
          };
        }
        // flip mapAttrs' nixosArgs.config.services.borgbackup.jobs (
          name: value:
          nameValuePair "borgbackup-job-${name}" {
            unitConfig.OnFailure = "notify-problems@%i.service";

            preStart = mkIf (name == "borgbase") (mkBefore ''
              # wait until DNS/route works
              until /run/wrappers/bin/ping -c1 -q m8yoakd9.repo.borgbase.com >/dev/null 2>&1; do
                sleep 2
              done
            '');

            wants = mkIf (name == "borgbase") [ "network-online.target" ];
            after = mkIf (name == "borgbase") [ "network-online.target" ];
          }
        );

        systemd.timers = flip mapAttrs' nixosArgs.config.services.borgbackup.jobs (
          name: value:
          nameValuePair "borgbackup-job-${name}" {
            timerConfig.Persistent = true;
          }
        );
      }
    ];
}
