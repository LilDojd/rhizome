{
  lib,
  config,
  ...
}:
let
  prefix = "nixosConfigurations/";
in
{
  text.readme.parts.nixos-configurations =
    # markdown
    ''
      ## NixOS configurations

      Configurations are declared by prefixing a module's name.

      > [!TIP]
      > This spares me of some boilerplate.
      > For example, see [`darkforest/imports`](modules/darkforest/imports.nix).

    '';

  flake = {
    nixosConfigurations =
      config.flake.modules.nixos or { }
      |> lib.filterAttrs (name: _module: lib.hasPrefix prefix name)
      |> lib.mapAttrs' (
        name: module:
        let
          hostName = lib.removePrefix prefix name;
        in
        {
          name = hostName;
          value = lib.nixosSystem {
            modules = [
              module
              { networking = { inherit hostName; }; }
            ];
            specialArgs = {
              nixosModules = config.flake.modules.nixos;
              diskoConfigurations = config.flake.diskoConfigurations or { };
            };
          };
        }
      );
    checks =
      config.flake.nixosConfigurations
      |> lib.mapAttrsToList (
        name: nixos: {
          ${nixos.config.nixpkgs.hostPlatform.system} = {
            "${prefix}${name}" = nixos.config.system.build.toplevel;
          };
        }
      )
      |> lib.mkMerge;
  };
}
