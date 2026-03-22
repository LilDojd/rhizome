{ inputs, ... }:
{
  flake.modules.nixos.foundation = {
    imports = [ inputs.determinate.nixosModules.default ];
  };
}
