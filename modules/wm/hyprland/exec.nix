{ lib, ... }:
{
  flake.modules.homeManager.hyprland = {
    # ashell is started via systemd (programs.ashell.systemd.enable = true)
    wayland.windowManager.hyprland.settings.on =
      map
        (cmd: {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline "function() hl.exec_cmd(${builtins.toJSON cmd}) end")
          ];
        })
        [
          "killall -q awww;sleep .5 && awww-daemon"
          "killall -q swaync;sleep .5 && swaync"
          "nm-applet --indicator"
          "pypr"
          "sleep 1.5 && awww img ~/backgrounds/spacegoose.png"
        ];
  };
}
