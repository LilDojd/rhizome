{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings.config.input.touchpad = {
      natural_scroll = true;
      disable_while_typing = true;
      scroll_factor = 0.8;
    };
    wayland.windowManager.sway.config.input."type:touchpad".tap = "enabled";
  };
}
