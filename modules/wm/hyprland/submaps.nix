{ lib, ... }:
{
  flake.modules.homeManager.hyprland = {
    options.wayland.windowManager.hyprland.submapEnd = lib.mkOption {
      type = lib.types.lines;
      default = ''
        bind = , escape, submap, reset
        bind = , catchall, exec, true
        submap = reset
      '';
    };
  };
}
