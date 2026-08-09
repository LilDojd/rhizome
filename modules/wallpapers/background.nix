{ lib, config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      "backgrounds"
    ];
  flake.modules.homeManager.hyprland =
    hmArgs@{ pkgs, ... }:

    let
      submap = "background";
      awwwExe = lib.getExe pkgs.awww;
      awwwDaemon = lib.getExe' pkgs.awww "awww-daemon";
      killall = lib.getExe' pkgs.psmisc "killall";
      sleep = lib.getExe' pkgs.coreutils "sleep";

      wallsetter = pkgs.writeShellApplication {
        name = "wallsetter";
        runtimeInputs = with pkgs; [
          awww
          findutils
          coreutils
          libnotify
          procps
        ];
        text = # sh
          ''
            TIMEOUT=720

            for pid in $(pidof -o %PPID -x wallsetter); do
              kill "$pid"
            done

            if ! [ -d "$HOME"/backgrounds ]; then notify-send -t 5000 "$HOME/backgrounds does not exist" && exit 1; fi
            mapfile -d "" WALLPAPERS < <(find "$HOME"/backgrounds -maxdepth 1 -type f -print0)
            if [ "''${#WALLPAPERS[@]}" -eq 0 ]; then notify-send -t 9000 "The wallpaper folder is empty. Exiting Wallsetter." && exit 1; fi

            PREVIOUS=
            while true; do
              if [ "''${#WALLPAPERS[@]}" -eq 1 ]; then
                WALLPAPER="''${WALLPAPERS[0]}"
              else
                WALLPAPER=$PREVIOUS
                while [ "$WALLPAPER" = "$PREVIOUS" ]; do
                  WALLPAPER="''${WALLPAPERS[RANDOM % ''${#WALLPAPERS[@]}]}"
                done
              fi

              PREVIOUS=$WALLPAPER

              awww img "$WALLPAPER" --transition-type random --transition-step 1 --transition-fps 60
              sleep $TIMEOUT
            done
          '';
      };
    in
    {
      xdg.userDirs.extraConfig.SS_DIR = "${hmArgs.config.home.homeDirectory}/backgrounds";

      home.packages = [
        pkgs.awww
        wallsetter
      ];

      wayland.windowManager.hyprland =
        let
          inline = lib.generators.mkLuaInline;
        in
        {
          settings = {
            config.misc.disable_hyprland_logo = true;

            on = [
              {
                _args = [
                  "hyprland.start"
                  (inline "function() hl.exec_cmd(${builtins.toJSON "${killall} -q awww-daemon;${sleep} .5 && ${awwwDaemon}"}) end")
                ];
              }
              {
                _args = [
                  "hyprland.start"
                  (inline "function() hl.exec_cmd(${builtins.toJSON "${sleep} 1.5 && ${awwwExe} img ~/backgrounds/spacegoose.png"}) end")
                ];
              }
            ];

            bind = [
              {
                _args = [
                  (inline ''modifier .. " + b"'')
                  (inline ''hl.dsp.submap("${submap}")'')
                ];
              }
            ];
          };

          submaps.${submap}.settings.bind = [
            {
              _args = [
                "n"
                (inline "hl.dsp.exec_cmd(${builtins.toJSON (lib.getExe wallsetter)})")
                { repeating = true; }
              ];
            }
            {
              _args = [
                "p"
                (inline "hl.dsp.exec_cmd(${builtins.toJSON "${awwwExe} img ~/backgrounds/spacegoose.png"})")
                { repeating = true; }
              ];
            }
            {
              _args = [
                "escape"
                (inline ''hl.dsp.submap("")'')
              ];
            }
            {
              _args = [
                "catchall"
                (inline ''hl.dsp.exec_cmd("true")'')
              ];
            }
          ];
        };

      # Ensure Pictures/Wallpapers directory exists for wallsetter script
      home.activation.wallpapersDir = hmArgs.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p $HOME/backgrounds
      '';
    };
}
