{ inputs, ... }:
{
  flake.modules.nixos.foundation = {
    imports = [ inputs.determinate.nixosModules.default ];
    environment.systemPackages = [ inputs.fh.packages."x86_64-linux".default ];
  };
}
