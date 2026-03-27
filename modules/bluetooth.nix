{ lib, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".directories = [
    "/var/lib/bluetooth"
  ];
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = lib.optionals (pkgs.stdenv.isLinux) [
        pkgs.bluetui
      ];
    };
}
