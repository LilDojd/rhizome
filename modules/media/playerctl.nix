{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    hmArgs@{ pkgs, ... }:
    let
      inherit (hmArgs.config.lib.stylix) colors;
      playerctl = lib.getExe pkgs.playerctl;
      exec = command: lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${playerctl} ${command}"})";
    in
    {
      home.packages = [ pkgs.playerctl ];

      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            "XF86AudioPlay"
            (exec "play-pause")
          ];
        }
        {
          _args = [
            "XF86AudioPause"
            (exec "play-pause")
          ];
        }
        {
          _args = [
            "XF86AudioNext"
            (exec "next")
          ];
        }
        {
          _args = [
            "XF86AudioPrev"
            (exec "previous")
          ];
        }
      ];

      programs.hyprlock.settings.label = [
        # CURRENT SONG
        {
          text = ''cmd[update:1000] echo "$(${playerctl} metadata --format '{{title}} | {{artist}}')"'';
          color = "rgba(255, 255, 255, 1)";
          font_size = 17;
          font_family = "${hmArgs.config.stylix.fonts.monospace.name}";
          position = "0, 200";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
}
