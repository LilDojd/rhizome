{ inputs, lib, ... }:
{
  flake.modules = {
    nixos.pc = {
      imports = [ inputs.nixos-facter-modules.nixosModules.facter ];
      facter.detected.dhcp.enable = false;
    };

    homeManager.base =
      { pkgs, ... }:
      {
        home.packages = lib.optionals pkgs.stdenv.isLinux [
          inputs.nixos-facter-modules.packages.${pkgs.system}.nixos-facter
        ];
      };
  };
}
