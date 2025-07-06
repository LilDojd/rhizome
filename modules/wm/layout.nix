{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings.general = {
      gaps_in = 6;
      gaps_out = 8;
      border_size = 2;
      resize_on_border = true;
    };
  };
}
