{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          bandwhich
          bind
          curl
          gping
          inetutils
          socat
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          ethtool
        ];
    };
}
