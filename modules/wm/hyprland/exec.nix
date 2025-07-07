{
  flake.modules.homeManager.hyprland =
    {
      wayland.windowManager.hyprland = {
        settings = {

          exec-once = [
            "wl-paste --type text --watch cliphist store # Stores only text data"
            "wl-paste --type image --watch cliphist store # Stores only image data"
            "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "systemctl --user start hyprpolkitagent"
            "killall -q swww;sleep .5 && swww-daemon"
            "killall -q waybar;sleep .5 && waybar"
            "killall -q swaync;sleep .5 && swaync"
            "nm-applet --indicator"
            "pypr &"
            "sleep 1.5 && swww img ~/backgrounds/spacegoose.png"
          ];
          };};
        };

}
