{
  flake.modules.homeManager.hyprland =
    {
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

      wayland.windowManager.hyprland.settings = {
        exec-once = [
          "clipse -listen"
        ];
        bind = [
          "$modifier,v,exec,${cmd}"
          "$modifier SHIFT,v,exec,clipse -clear"
        ];
        windowrule = [
          "float on, match:class ^(clipse)$"
          "stay_focused on, match:class ^(clipse)$"
          "move cursor 0 0, match:class ^(clipse)$"
          "center on, match:class ^(clipse)$"
          "pin on, match:class ^(clipse)$"
          "opacity on, match:class ^(clipse)$"
          "no_anim on, match:class ^(clipse)$"
          "no_anim on, match:class ^(clipse)$"
          "immediate on, match:class ^(clipse)$"
          "suppress_event fullscreen maximize, match:class ^(clipse)$"
        ];
      };
    };
}
