{ inputs, ... }:
{
  flake-file.inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

  flake.modules = {
    nixos.foundation = {
      imports = [ inputs.nixos-facter-modules.nixosModules.facter ];
      facter.detected.dhcp.enable = false;
    };

    homeManager.linux =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.nixos-facter ];
      };
  };
}
