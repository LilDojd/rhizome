{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackagesFor (
        pkgs.linux_latest.override {
          argsOverride = rec {
            version = "7.0.11";
            modDirVersion = version;
            src = pkgs.fetchurl {
              url = "mirror://kernel/linux/kernel/v7.x/linux-${version}.tar.xz";
              hash = "sha256-5WyDVt2gETamBBxu+DK9Dsmb0tNd/5eDKqXsEO0BQwQ=";
            };
          };
        }
      );
      boot.kernel.sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };
    };
}
