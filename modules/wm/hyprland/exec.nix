{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "killall -q swww;sleep .5 && swww-daemon"
          "killall -q waybar;sleep .5 && waybar"
          "killall -q swaync;sleep .5 && swaync"
          "nm-applet --indicator"
          "uwsm finalize"
          "uwsm app -- pypr"
          "sleep 1.5 && swww img ~/backgrounds/spacegoose.png"
        ];
      };
    };
  };

}
