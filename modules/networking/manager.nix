{ lib, ... }:
{
  flake.modules = {
    nixos.pc = {
      networking = {
        wireless.iwd = {
          enable = true;
          settings = {
            IPv6.Enabled = true;
            Settings.AutoConnect = true;
          };
        };
        networkmanager.wifi.backend = "iwd";
      };
    };

    homeManager.base =
      { pkgs, ... }:
      {
        home.packages = lib.optionals pkgs.stdenv.isLinux [
          pkgs.impala
        ];
      };
  };
}
