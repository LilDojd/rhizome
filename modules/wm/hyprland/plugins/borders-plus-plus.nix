{ inputs, lib, ... }:
{
  flake.modules.homeManager.hyprland =
    hmArgs@{ pkgs, ... }:
    let
      hyprland = hmArgs.config.wayland.windowManager.hyprland.package;
      borders-plus-plus =
        inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.borders-plus-plus.overrideAttrs
          (old: {
            inherit (hyprland) nativeBuildInputs;
            buildInputs = builtins.filter (input: lib.getName input != "hyprland") old.buildInputs ++ [
              hyprland
            ];
          });
    in
    {
      wayland.windowManager.hyprland = {
        plugins = [ borders-plus-plus ];
        settings.config.plugin.borders_plus_plus = {
          add_borders = 1;
          natural_rounding = true;
          col.border_1 = "rgb(${hmArgs.config.lib.stylix.colors.base0D})";
          border_size_1 = 3;
        };
      };
    };
}
