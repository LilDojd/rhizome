{ config, ... }:
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings.monitor = config.flake.meta.owner.preferences.monitors;
  };
}
