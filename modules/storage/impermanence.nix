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
      find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30 -exec bash -c 'delete_subvolume_recursively "$0"' {} \;

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
            wants = [ "-dev-disk-by\x2dpartlabel-disk\x2dprimary\x2droot.device" ];
            after = [ "-dev-disk-by\x2dpartlabel-disk\x2dprimary\x2droot.device" ];
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
          "/etc/NetworkManager/system-connections"
          "/var/lib/sops/age"
          "/var/lib/bluetooth"
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

            ".local/share/Steam"
            ".steam"
            ".config/heroic"

            ".local/share/applications"
            ".local/share/onlyoffice"

            ".config/Slack"

            ".config/google-chrome"
            ".zen"
            ".mozilla"
            ".librewolf"

            ".local/share/zoxide"
            ".cache/zsh"

            ".cache/nsearch"

            ".local/share/nvim"
            ".local/state/nvim"
            ".local/state/nix/profiles/channels" # determinate nix log spam fix
            ".config/github-copilot"
            ".cache/nvim"

            ".cache/nix-index"
            ".android"

            ".local/state/lazygit"
            ".local/share/direnv"

            ".local/state/mpv"

            ".config/discord"

            ".config/Proton"
            ".config/Proton Pass"

            ".local/share/TelegramDesktop"
            ".local/share/materialgram"
            ".cache/stylix-telegram-theme"

            ".local/state/wireplumber"
            ".config/pulse"
            ".config/Mailspring"
            ".cursor"

            ".local/share/fish"
            "Downloads"
            "Pictures"
            "Documents"
            "Videos"

            "repos"
            "work"
            "share"
            "temp"
            "rhizome"
            "backgrounds"
            ".config/fish"
            ".config/blender"
            ".cache/nix"
            ".config/1Password"
            "1Password"

            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".ssh";
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
            ".temp.zsh"
            ".gtasks_credentials.pickle"
            "screen/.screenrc"
          ];
        };
      };
    };
  };
}
