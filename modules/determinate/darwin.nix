{ inputs, config, ... }:
{
  flake.modules.darwin.foundation = {
    imports = [ inputs.determinate.darwinModules.default ];
    environment.systemPackages = [ inputs.fh.packages."aarch64-darwin".default ];
    nix.enable = false;
    determinateNix.customSettings = config.nix.settings // {
      trusted-users = [ config.flake.meta.owner.username ];
    };
  };
}
