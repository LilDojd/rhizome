{ lib, config, ... }:
{
  options.nixpkgs.overlays = lib.mkOption {
    type = lib.types.listOf lib.types.raw;
    default = [ ];
    description = "List of overlays to apply globally";
  };

  config.flake = {
    modules = {
      nixos.foundation.nixpkgs.overlays = config.nixpkgs.overlays;
      darwin.foundation.nixpkgs.overlays = config.nixpkgs.overlays;

      homeManager.base = args: {
        nixpkgs.overlays = lib.mkIf (!(args.hasGlobalPkgs or false)) config.nixpkgs.overlays;
      };
    };

    meta.nixpkgs.overlays = config.nixpkgs.overlays;
  };
}
