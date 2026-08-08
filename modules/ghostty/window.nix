{ lib, ... }:
{
  flake.modules.homeManager.gui.programs.ghostty.settings = {
    window-theme = "dark";
    window-height = 32;
    window-width = 110;
    window-save-state = "always";
    window-padding-x = 4;
    window-padding-y = 4;
    confirm-close-surface = true;
    resize-overlay = "always";
    focus-follows-mouse = true;
    mouse-scroll-multiplier = 2;
    gtk-single-instance = true;
  };

  flake.modules.homeManager.hyprland.wayland.windowManager.hyprland.settings.window_rule =
    lib.mkBefore
      [
        {
          match.class = "^(com\\.mitchellh\\.ghostty)$";
          tag = "+terminal";
        }
      ];
}
