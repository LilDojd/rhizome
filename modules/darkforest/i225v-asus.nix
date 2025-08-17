{
  flake.modules.nixos."nixosConfigurations/darkforest" = { pkgs, ... }:
  let
    guard_asus_pl = pkgs.writeText "guard_asus.pl" ''
      #!/usr/bin/env perl
      use 5.024;
      use strict;
      use warnings;
      use Data::Dumper;

      # igc 0000:0b:00.0 eno1: PCIe link lost, device now detached

      say 'Watching for asus-bug to occur';

      while (<>) {
          next unless /igc (\S+) .*+ PCIe link lost, device now detached/;
          fix_asus($1);
      }

      sub fix_asus {
          my $id = shift;
          say "Resetting $id";
          system("echo 1 > /sys/bus/pci/devices/$id/remove");
          sleep 1;
          system("echo 1 > /sys/bus/pci/rescan");
      }
    '';

    guard_asus_sh = pkgs.writeShellScript "guard_asus.sh" ''
      set -eu -o pipefail
      ${pkgs.util-linux}/bin/dmesg -W | ${pkgs.perl}/bin/perl ${guard_asus_pl}
    '';
  in
  {
    systemd.services.guard-asus = {
      description = "Asus Bug watcher Daemon";
      after = [ "syslog.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "root";
        Group = "root";
        Type = "simple";
        ExecStart = guard_asus_sh;
        KillMode = "process";
        Restart = "always";
      };
    };
  };
}
