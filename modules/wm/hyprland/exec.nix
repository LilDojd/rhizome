{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "killall -q swww;sleep .5 && swww-daemon"
          # ashell is started via systemd (programs.ashell.systemd.enable = true)
          "killall -q swaync;sleep .5 && swaync"
          "nm-applet --indicator"
          "pypr"
          "sleep 1.5 && swww img ~/backgrounds/spacegoose.png"
        ];
      };
    };
  };

}
