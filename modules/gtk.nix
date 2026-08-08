{
  flake.modules = {
    homeManager.linux =
      { pkgs, ... }:
      {
        wayland.windowManager.sway.wrapperFeatures.gtk = true;
        gtk = {
          enable = true;
          iconTheme = {
            package = pkgs.dracula-icon-theme;
            name = "Dracula";
          };
        };
      };
    homeManager.hyprland.wayland.windowManager.hyprland.settings.env = [
      {
        _args = [
          "GDK_BACKEND"
          "wayland,x11"
        ];
      }
      {
        _args = [
          "CLUTTER_BACKEND"
          "wayland"
        ];
      }
      {
        _args = [
          "GDK_SCALE"
          "2"
        ];
      }
    ];
  };
}
