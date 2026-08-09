{
  flake.modules.homeManager.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      type = "kitty";
      clipse = pkgs.writeShellApplication {
        name = "clipse";
        runtimeInputs = [
          pkgs.clipse
          pkgs.wl-clipboard
        ];
        text = ''exec ${lib.getExe pkgs.clipse} "$@"'';
      };
      clipseExe = lib.getExe clipse;
      cmd = "${lib.getExe config.programs.kitty.package} --class 'clipse' -e ${clipseExe}";
    in
    {
      home.packages = [
        clipse
        pkgs.wl-clipboard
      ];
      programs.ashell.settings.CustomModule = [
        {
          name = "Clipboard";
          icon = "󰅍";
          command = cmd;
        }
      ];
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
                (inline "function() hl.exec_cmd(${builtins.toJSON "${clipseExe} -listen"}) end")
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
                (inline "hl.dsp.exec_cmd(${builtins.toJSON "${clipseExe} -clear"})")
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
