{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    let
      mkEnv = name: value: {
        _args = [
          name
          value
        ];
      };
    in
    {
      wayland.windowManager.hyprland.settings = {
        env = [
          (mkEnv "NIXOS_OZONE_WL" "1")
          (mkEnv "XDG_CURRENT_DESKTOP" "Hyprland")
          (mkEnv "XDG_SESSION_TYPE" "wayland")
          (mkEnv "XDG_SESSION_DESKTOP" "Hyprland")
          (mkEnv "GDK_BACKEND" "wayland,x11")
          (mkEnv "CLUTTER_BACKEND" "wayland")
          (mkEnv "QT_QPA_PLATFORM" "wayland;xcb")
          (mkEnv "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")
          (mkEnv "QT_AUTO_SCREEN_SCALE_FACTOR" "1")
          (mkEnv "SDL_VIDEODRIVER" "x11")
          (mkEnv "MOZ_ENABLE_WAYLAND" "1")
          (mkEnv "GDK_SCALE" "2")
          (mkEnv "QT_SCALE_FACTOR" "1")
          (mkEnv "EDITOR" "hx")
          (mkEnv "TERMINAL" (lib.getExe pkgs.kitty))
          (mkEnv "WLR_NO_HARDWARE_CURSORS" "1")
          (mkEnv "LIBVA_DRIVER_NAME" "nvidia")
          (mkEnv "__GLX_VENDOR_LIBRARY_NAME" "nvidia")
        ];
      };
    };
}
