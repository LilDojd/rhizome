{
  flake.modules = {
    homeManager.linux.qt.enable = true;
    homeManager.hyprland.wayland.windowManager.hyprland.settings.env = [
      {
        _args = [
          "QT_QPA_PLATFORM"
          "wayland;xcb"
        ];
      }
      {
        _args = [
          "QT_WAYLAND_DISABLE_WINDOWDECORATION"
          "1"
        ];
      }
      {
        _args = [
          "QT_AUTO_SCREEN_SCALE_FACTOR"
          "1"
        ];
      }
      {
        _args = [
          "QT_SCALE_FACTOR"
          "1"
        ];
      }
    ];
  };
}
