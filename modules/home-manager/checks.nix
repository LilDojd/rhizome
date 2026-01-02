{
  config,
  lib,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      checks =
        {
          base = with config.flake.modules.homeManager; [ base ];
          gui = with config.flake.modules.homeManager; [
            base
            gui
          ];
        }
        // lib.optionalAttrs (pkgs.stdenv.isLinux) {
          hyprland = with config.flake.modules.homeManager; [
            hyprland
            linux
            base
            gui
          ];
        }
        |> lib.mapAttrs' (
          name: modules: {
            name = "home-manager/${name}";
            value =
              {
                inherit pkgs;
                modules = modules ++ [ { home.stateVersion = "25.11"; } ];
              }
              |> inputs.home-manager.lib.homeManagerConfiguration
              |> lib.getAttrFromPath [
                "config"
                "home-files"
              ];
          }
        );
    };
}
