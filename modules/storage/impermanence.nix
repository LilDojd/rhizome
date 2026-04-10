{
  inputs,
  config,
  ...
}:
let
  mount = "/dev/disk/by-partlabel/disk-primary-root";

  cleanup =
    # bash
    ''
      # This script cleans the disk at boot to have clean setup
      # also keeps backup of the previous boot
      mkdir -p /btrfs_tmp
      mount ${mount} /btrfs_tmp -t btrfs
      if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%b-%d-%Y_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      # Deleting backup older than 30 days
      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
in
{
  flake.modules.nixos.foundation = {
    imports = [ inputs.impermanence.nixosModules.impermanence ];
    config = {
      security.sudo.extraConfig = "Defaults lecture=never";
      fileSystems."/persistent".neededForBoot = true;

      boot.initrd = {
        systemd = {
          services.wipe-my-fs = {
            wantedBy = [ "initrd.target" ];
            wants = [ "dev-disk-by\\x2dpartlabel-disk\\x2dprimary\\x2droot.device" ];
            after = [ "dev-disk-by\\x2dpartlabel-disk\\x2dprimary\\x2droot.device" ];
            before = [ "sysroot.mount" ];
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = cleanup;
          };
        };
      };
      environment.persistence."/persistent" = {
        enable = true;
        hideMounts = true;
        directories = [
          "/etc/nixos"
          "/etc/secureboot"
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/libvirt"
          # Systemd requires /usr dir to be populated
          # See: https://github.com/nix-community/impermanence/issues/253
          "/usr/systemd-placeholder"
        ];
        users.${config.flake.meta.owner.username} = {
          directories = [
            ".config/kdeconnect"
            ".config/kde.org"

            ".local/share/task"
            ".config/syncall"

            ".config/heroic"

            ".local/share/applications"
            ".local/share/onlyoffice"
            ".local/share/Larian Studios"

            ".config/google-chrome"
            ".zen"
            ".librewolf"

            ".cache/nsearch"
            ".cache/radv_builtin_shaders"

            ".android"

            ".config/Proton Pass"
            ".config/Mailspring"
            ".config/glab-cli"
            ".claude"

            "Downloads"
            "Pictures"
            "Games"
            "Documents"
            "Videos"

            "repos"
            "work"
            "share"
            "temp"
            "rhizome"

            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".nixops";
              mode = "0700";
            }
            {
              directory = ".local/share/keyrings";
              mode = "0700";
            }
          ];

          files = [
            ".gtasks_credentials.pickle"
            ".claude.json"
            "screen/.screenrc"
          ];
        };
      };
    };
  };
}
