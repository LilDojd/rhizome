{ config, ... }:
let
  inherit (config.flake.meta.owner.preferences) monitorSettings;
in
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.extraConfig = ''
      ${monitorSettings}
    '';
  };
}
