{ inputs, ... }:
{
  flake.modules.nixos.foundation = {
    imports = [ inputs.clipboard-sync.nixosModules.default ];
    services.clipboard-sync.enable = true;
  };
}
