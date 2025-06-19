{
  lib,
  config,
  inputs,
  ...
}:
let
  prefix = "darwinConfigurations/";
in
{
  flake = {
    darwinConfigurations =
      config.flake.modules.darwin or { }
      |> lib.filterAttrs (name: _module: lib.hasPrefix prefix name)
      |> lib.mapAttrs' (
        name: module:
        let
          hostName = lib.removePrefix prefix name;
        in
        {
          name = hostName;
          value = inputs.nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = [
              module
              {
                networking.hostName = lib.mkDefault hostName;
                nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
                system.stateVersion = 6;
              }
            ];
          };
        }
      );

    checks =
      config.flake.darwinConfigurations
      |> lib.mapAttrsToList (
        name: darwin: {
          ${darwin.config.nixpkgs.hostPlatform.system} = {
            "${prefix}${name}" = darwin.config.system.build.toplevel;
          };
        }
      )
      |> lib.mkMerge;
  };
}
