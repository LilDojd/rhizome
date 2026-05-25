{
  flake.modules.homeManager.hyprland =
    {
      lib,
      pkgs,
      ...
    }:
    let
      type = "kitty";
      cmd = "kitty --class 'clipse' -e clipse";
    in
    {
      home.packages = with pkgs; [ clipse ];
      home.file.".config/clipse/config.json".text =
        # json
        ''
          {
            "historyFile": "clipboard_history.json",
            "maxHistory": 1000,
            "allowDuplicates": false,
            "themeFile": "custom_theme.json",
            "tempDir": "tmp_files",
            "logFile": "clipse.log",
            "keyBindings": {
              "choose": "enter",
              "clearSelected": "D",
              "down": "j",
              "end": "G",
              "filter": "/",
              "home": "home",
              "more": "?",
              "nextPage": ">",
              "prevPage": "<",
              "preview": "P",
              "quit": "q",
              "remove": "d",
              "selectDown": "ctrl+down",
              "selectSingle": "enter",
              "selectUp": "ctrl+up",
              "togglePin": "p",
              "togglePinned": "tab",
              "up": "k",
              "yankFilter": "y"
             },
            "imageDisplay": {
              "type": "${type}",
              "scaleX": 16,
              "scaleY": 18,
              "heightCut": 2
             }
          }
        '';

      wayland.windowManager.hyprland.settings =
        let
          inline = lib.generators.mkLuaInline;
          clipseMatch = {
            class = "^(clipse)$";
          };
        in
        {
          on = [
            {
              _args = [
                "hyprland.start"
                (inline ''function() hl.exec_cmd("clipse -listen") end'')
              ];
            }
          ];
          bind = [
            {
              _args = [
                (inline ''modifier .. " + v"'')
                (inline "hl.dsp.exec_cmd(${builtins.toJSON cmd})")
              ];
            }
            {
              _args = [
                (inline ''modifier .. " + SHIFT + v"'')
                (inline ''hl.dsp.exec_cmd("clipse -clear")'')
              ];
            }
          ];
          window_rule = [
            {
              match = clipseMatch;
              float = true;
            }
            {
              match = clipseMatch;
              stay_focused = true;
            }
            {
              match = clipseMatch;
              move = "cursor 0 0";
            }
            {
              match = clipseMatch;
              center = true;
            }
            {
              match = clipseMatch;
              pin = true;
            }
            {
              match = clipseMatch;
              opacity = "1.0";
            }
            {
              match = clipseMatch;
              no_anim = true;
            }
            {
              match = clipseMatch;
              immediate = true;
            }
            {
              match = clipseMatch;
              suppress_event = "fullscreen maximize";
            }
          ];
        };
    };
}
