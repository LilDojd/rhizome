{ lib, ... }:
{
  flake.modules.nixos.foundation = {
    environment.persistence."/persistent".directories = [
      "/var/lib/bluetooth"
    ];
    hardware.bluetooth.enable = true;
  };
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
        pkgs.bluetui
      ];
    };
}
