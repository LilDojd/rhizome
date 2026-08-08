{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    let
      class = "kitty-dropterm";
    in
    {
      home.packages = with pkgs; [ pyprland ];

      wayland.windowManager.hyprland.settings.bind = [
        {
          _args = [
            (lib.generators.mkLuaInline ''modifier .. " + T"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${lib.getExe pkgs.pyprland} toggle term"})")
          ];
        }
      ];

      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline "function() hl.exec_cmd(${builtins.toJSON (lib.getExe pkgs.pyprland)}) end")
          ];
        }
      ];

      wayland.windowManager.hyprland.settings.window_rule = lib.mkBefore [
        {
          match.class = "^${class}$";
          tag = "+terminal";
        }
      ];

      home.file.".config/pypr/config.toml".text = ''
        [pyprland]
        plugins = [
          "scratchpads",
        ]

        [scratchpads.term]
        animation = "fromTop"
        command = "kitty --class=${class}"
        class = "${class}"
        size = "70% 70%"
        max_size = "1920px 100%"
        position = "150px 150px"
      '';
    };
}
