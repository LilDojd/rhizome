{ inputs, config, ... }:
{
  flake.modules.darwin.foundation = {
    imports = [ inputs.determinate.darwinModules.default ];
    environment.systemPackages = [ inputs.fh.packages."aarch64-darwin".default ];
    nix.enable = false;
    determinateNix.customSettings = config.nix.settings // {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      trusted-users = [ config.flake.meta.yawner.username ];
    };
  };
}
