{ inputs, lib, ... }:
{
  flake.modules.homeManager.hyprland =
    hmArgs@{ pkgs, ... }:
    let
      hyprland = hmArgs.config.wayland.windowManager.hyprland.package;
      hyprfocus =
        inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprfocus.overrideAttrs
          (old: {
            inherit (hyprland) nativeBuildInputs;
            buildInputs = builtins.filter (input: lib.getName input != "hyprland") old.buildInputs ++ [
              hyprland
            ];
          });
    in
    {
      wayland.windowManager.hyprland = {
        plugins = [ hyprfocus ];
        settings = {
          config.plugin.hyprfocus = {
            enable = true;
            animate_floating = true;
            only_on_monitor_change = false;
            keyboard_focus_animation = "flash";
            mouse_focus_animation = "none";
            fade_opacity = 0.85;
          };
          animation = [
            {
              leaf = "hyprfocusIn";
              enabled = true;
              speed = 2;
              bezier = "md3_decel";
            }
            {
              leaf = "hyprfocusOut";
              enabled = true;
              speed = 2;
              bezier = "md3_decel";
            }
          ];
        };
      };
    };
}
