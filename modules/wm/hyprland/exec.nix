{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      settings = {
        exec_cmd = [
          "killall -q awww;sleep .5 && awww-daemon"
          # ashell is started via systemd (programs.ashell.systemd.enable = true)
          "killall -q swaync;sleep .5 && swaync"
          "nm-applet --indicator"
          "pypr"
          "sleep 1.5 && awww img ~/backgrounds/spacegoose.png"
        ];
      };
    };
  };

}
