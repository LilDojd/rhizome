{ inputs, lib, ... }:
{
  flake.modules = {
    nixos.foundation = {
      imports = [ inputs.nixos-facter-modules.nixosModules.facter ];
      facter.detected.dhcp.enable = false;
    };

    homeManager.base =
      { pkgs, ... }:
      {
        home.packages = lib.optionals pkgs.stdenv.isLinux [
          pkgs.nixos-facter
        ];
      };
  };
}
