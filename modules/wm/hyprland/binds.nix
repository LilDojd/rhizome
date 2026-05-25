{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    let
      inline = lib.generators.mkLuaInline;

      bind = key: disp: { _args = [ key disp ]; };
      bindOpts = key: disp: opts: { _args = [ key disp opts ]; };

      withMod =
        extras: key:
        let
          suffix = lib.concatStringsSep " + " (extras ++ [ key ]);
        in
        inline ''modifier .. " + ${suffix}"'';
      keys = lib.concatStringsSep " + ";

      killactive = inline "hl.dsp.window.close()";
      pseudo = inline "hl.dsp.window.pseudo()";
      fullscreen = inline "hl.dsp.window.fullscreen()";
      togglefloating = inline ''hl.dsp.window.float({ action = "toggle" })'';
      togglesplit = inline ''hl.dsp.layout("togglesplit")'';
      exit = inline "hl.dsp.exit()";
      togglespecial = inline ''hl.dsp.workspace.toggle_special("")'';
      cyclenext = inline "hl.dsp.window.cycle_next()";
      bringtotop = inline "hl.dsp.window.bring_to_top()";
      # No first-class Lua API for workspaceopt yet; fall back through hyprctl.
      workspaceoptAllfloat = inline ''hl.dsp.exec_raw("dispatch workspaceopt allfloat")'';
      windowDrag = inline "hl.dsp.window.drag()";
      windowResize = inline "hl.dsp.window.resize()";

      exec = cmd: inline ''hl.dsp.exec_cmd(${builtins.toJSON cmd})'';
      movefocus = dir: inline ''hl.dsp.focus({ direction = "${dir}" })'';
      movewindow = dir: inline ''hl.dsp.window.move({ direction = "${dir}" })'';
      swapwindow = dir: inline ''hl.dsp.window.swap({ direction = "${dir}" })'';
      workspace = ws: inline ''hl.dsp.focus({ workspace = ${builtins.toJSON ws} })'';
      movetoworkspace =
        ws: inline ''hl.dsp.window.move({ workspace = ${builtins.toJSON ws}, follow = false })'';
      resizeactive =
        x: y:
        inline ''hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })'';
    in
    {
      wayland.windowManager.hyprland.settings = {
        bind = [
          (bind (withMod [ ] "Return") (exec (lib.getExe pkgs.kitty)))
          (bind (withMod [ ] "K") (exec "list-keybinds"))
          (bind (withMod [ "SHIFT" ] "Return") (exec "rofi-launcher"))
          (bind (withMod [ ] "W") (exec (lib.getExe pkgs.firefox)))
          (bind (withMod [ ] "D") (exec "vesktop"))
          (bind (withMod [ ] "O") (exec "obs"))
          (bind (withMod [ ] "C") (exec "hyprpicker -a"))
          (bind (withMod [ ] "G") (exec "gimp"))
          (bind (withMod [ ] "T") (exec "pypr toggle term"))
          (bind (withMod [ ] "M") (exec "pwvucontrol"))

          (bind (withMod [ ] "Q") killactive)
          (bind (withMod [ ] "P") pseudo)
          (bind (withMod [ "SHIFT" ] "I") togglesplit)
          (bind (withMod [ ] "F") fullscreen)
          (bind (withMod [ "SHIFT" ] "F") togglefloating)
          (bind (withMod [ "ALT" ] "F") workspaceoptAllfloat)
          (bind (withMod [ "SHIFT" ] "C") exit)

          (bind (withMod [ "SHIFT" ] "left") (movewindow "left"))
          (bind (withMod [ "SHIFT" ] "right") (movewindow "right"))
          (bind (withMod [ "SHIFT" ] "up") (movewindow "up"))
          (bind (withMod [ "SHIFT" ] "down") (movewindow "down"))
          (bind (withMod [ "SHIFT" ] "h") (movewindow "left"))
          (bind (withMod [ "SHIFT" ] "l") (movewindow "right"))
          (bind (withMod [ "SHIFT" ] "k") (movewindow "up"))
          (bind (withMod [ "SHIFT" ] "j") (movewindow "down"))

          (bind (withMod [ "ALT" ] "left") (swapwindow "left"))
          (bind (withMod [ "ALT" ] "right") (swapwindow "right"))
          (bind (withMod [ "ALT" ] "up") (swapwindow "up"))
          (bind (withMod [ "ALT" ] "down") (swapwindow "down"))
          (bind (withMod [ "ALT" ] "code:43") (swapwindow "left"))
          (bind (withMod [ "ALT" ] "code:46") (swapwindow "right"))
          (bind (withMod [ "ALT" ] "code:45") (swapwindow "up"))
          (bind (withMod [ "ALT" ] "code:44") (swapwindow "down"))

          (bind (withMod [ ] "left") (movefocus "left"))
          (bind (withMod [ ] "right") (movefocus "right"))
          (bind (withMod [ ] "up") (movefocus "up"))
          (bind (withMod [ ] "down") (movefocus "down"))
          (bind (withMod [ ] "h") (movefocus "left"))
          (bind (withMod [ ] "l") (movefocus "right"))
          (bind (withMod [ ] "k") (movefocus "up"))
          (bind (withMod [ ] "j") (movefocus "down"))

          (bind (withMod [ ] "1") (workspace "1"))
          (bind (withMod [ ] "2") (workspace "2"))
          (bind (withMod [ ] "3") (workspace "3"))
          (bind (withMod [ ] "4") (workspace "4"))
          (bind (withMod [ ] "5") (workspace "5"))
          (bind (withMod [ ] "6") (workspace "6"))
          (bind (withMod [ ] "7") (workspace "7"))
          (bind (withMod [ ] "8") (workspace "8"))
          (bind (withMod [ ] "9") (workspace "9"))
          (bind (withMod [ ] "0") (workspace "10"))

          (bind (withMod [ "SHIFT" ] "SPACE") (movetoworkspace "special"))
          (bind (withMod [ ] "SPACE") togglespecial)

          (bind (withMod [ "SHIFT" ] "1") (movetoworkspace "1"))
          (bind (withMod [ "SHIFT" ] "2") (movetoworkspace "2"))
          (bind (withMod [ "SHIFT" ] "3") (movetoworkspace "3"))
          (bind (withMod [ "SHIFT" ] "4") (movetoworkspace "4"))
          (bind (withMod [ "SHIFT" ] "5") (movetoworkspace "5"))
          (bind (withMod [ "SHIFT" ] "6") (movetoworkspace "6"))
          (bind (withMod [ "SHIFT" ] "7") (movetoworkspace "7"))
          (bind (withMod [ "SHIFT" ] "8") (movetoworkspace "8"))
          (bind (withMod [ "SHIFT" ] "9") (movetoworkspace "9"))
          (bind (withMod [ "SHIFT" ] "0") (movetoworkspace "10"))

          (bind (withMod [ "CONTROL" ] "right") (workspace "e+1"))
          (bind (withMod [ "CONTROL" ] "left") (workspace "e-1"))
          (bind (withMod [ ] "mouse_down") (workspace "e+1"))
          (bind (withMod [ ] "mouse_up") (workspace "e-1"))

          (bind (keys [ "ALT" "Tab" ]) cyclenext)
          (bind (keys [ "ALT" "Tab" ]) bringtotop)

          (bind "XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
          (bind "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
          (bind "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
          (bind "XF86AudioPlay" (exec "playerctl play-pause"))
          (bind "XF86AudioPause" (exec "playerctl play-pause"))
          (bind "XF86AudioNext" (exec "playerctl next"))
          (bind "XF86AudioPrev" (exec "playerctl previous"))
          (bind "XF86MonBrightnessDown" (exec "brightnessctl set 5%-"))
          (bind "XF86MonBrightnessUp" (exec "brightnessctl set +5%"))

          (bind (withMod [ "CTRL" ] "h") (resizeactive (-50) 0))
          (bind (withMod [ "CTRL" ] "l") (resizeactive 50 0))
          (bind (withMod [ "CTRL" ] "j") (resizeactive 0 50))
          (bind (withMod [ "CTRL" ] "k") (resizeactive 0 (-50)))

          (bindOpts (withMod [ ] "mouse:272") windowDrag { mouse = true; })
          (bindOpts (withMod [ ] "mouse:273") windowResize { mouse = true; })
        ];
      };
    };
}
