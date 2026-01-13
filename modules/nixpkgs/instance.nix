{
  lib,
  config,
  inputs,
  withSystem,
  ...
}:
{
  options.nixpkgs = {
    config = {
      allowUnfreePredicate = lib.mkOption {
        type = lib.types.functionTo lib.types.bool;
        default = _: false;
      };
    };
    overlays = lib.mkOption {
      type = lib.types.listOf lib.types.unspecified;
      default = [ ];
    };
  };

  config = {
    perSystem =
      { inputs', ... }:
      let
        inherit (inputs'.nixpkgs.legacyPackages.stdenv.hostPlatform) system;
      in
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          inherit (config.nixpkgs) config overlays;
        };
      };

    flake.modules.nixos.foundation = nixosArgs: {
      nixpkgs = {
        pkgs = withSystem nixosArgs.config.facter.report.system (psArgs: psArgs.pkgs);
        hostPlatform = nixosArgs.config.facter.report.system;
      };
    };
    flake.modules.darwin.foundation = {
      nixpkgs = {
        pkgs = withSystem (builtins.head config.systems) (psArgs: psArgs.pkgs);
        hostPlatform = (builtins.head config.systems);
      };
    };
  };
}
