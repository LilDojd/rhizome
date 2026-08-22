{
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [ ".local/share/chatterino" ];

  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.chatterino2 ];
    };

  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    let
      chatterino = lib.getExe pkgs.chatterino2;
      showChat = pkgs.writeShellApplication {
        name = "show-twitch-chat";
        runtimeInputs = with pkgs; [
          chatterino2
          hyprland
          procps
        ];
        text = ''
          if ! pgrep -x chatterino >/dev/null; then
            chatterino >/dev/null 2>&1 &
          fi
          hyprctl dispatch workspace 11
        '';
      };
    in
    {
      home.packages = [ showChat ];

      wayland.windowManager.hyprland.settings = {
        bind = [
          {
            _args = [
              (lib.generators.mkLuaInline ''modifier .. " + C"'')
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON (lib.getExe showChat)})")
            ];
          }
        ];

        on = [
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline "function() hl.exec_cmd(${builtins.toJSON chatterino}) end")
            ];
          }
        ];

        window_rule = lib.mkBefore [
          {
            match.class = "^(chatterino)$";
            monitor = "DP-3";
          }
          {
            match.class = "^(chatterino)$";
            workspace = "11";
          }
          {
            match.class = "^(chatterino)$";
            opacity = "1.0";
          }
        ];
      };
    };
}
