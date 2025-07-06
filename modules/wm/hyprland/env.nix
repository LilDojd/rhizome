{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings = {
        env = [
          "NIXOS_OZONE_WL, 1"
          "XDG_CURRENT_DESKTOP, Hyprland"
          "XDG_SESSION_TYPE, wayland"
          "XDG_SESSION_DESKTOP, Hyprland"
          "GDK_BACKEND, wayland, x11"
          "CLUTTER_BACKEND, wayland"
          "QT_QPA_PLATFORM, wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
          "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
          "SDL_VIDEODRIVER, x11"
          "MOZ_ENABLE_WAYLAND, 1"
          "GDK_SCALE,2"
          "QT_SCALE_FACTOR,1"
          "EDITOR,hx"
          "TERMINAL,${lib.getExe pkgs.ghostty}"
          "WLR_NO_HARDWARE_CURSORS,1"
          "LIBVA_DRIVER_NAME,nvidia"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        ];
      };
    };
}
