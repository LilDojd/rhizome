{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    hmArgs@{ config, pkgs, ... }:

    let
      submap = "background";

      wallsetter = pkgs.writeShellApplication {
        name = "wallsetter";
        runtimeInputs = with pkgs; [
          swww
          findutils
          coreutils
          libnotify
        ];
        text = ''
          #!/bin/bash
          TIMEOUT=720

          for pid in $(pidof -o %PPID -x wallsetter); do
            kill "$pid"
          done

          if ! [ -d "$HOME"/backgrounds ]; then notify-send -t 5000 "$HOME/backgrounds does not exist" && exit 1; fi
          if [ "$(find "$HOME"/backgrounds -maxdepth 1 -type f | wc -l)" -lt 1 ]; then	notify-send -t 9000 "The wallpaper folder is expected to have more than 1 image. Exiting Wallsetter." && exit 1; fi

          while true; do
          while [ "$WALLPAPER" == "$PREVIOUS" ]; do
          WALLPAPER=$(find "$HOME"/backgrounds -name '*' | awk '!/.git/' | tail -n +2 | shuf -n 1)
          done

            PREVIOUS=$WALLPAPER

            swww img "$WALLPAPER" --transition-type random --transition-step 1 --transition-fps 60
            sleep $TIMEOUT
          done
        '';
      };
    in
    {
      home.packages = [ wallsetter ];

      wayland.windowManager.hyprland = {
        settings.misc.disable_hyprland_logo = true;

        extraConfig = ''
          submap = ${submap}
          binde = , n, exec, ${lib.getExe wallsetter}
          binde = , p, exec, swww img ~/.config/wallpapers/spacegoose.png
          ${config.wayland.windowManager.hyprland.submapEnd}
          bind = $modifier, b, submap, ${submap}
        '';
      };

      # Ensure Pictures/Wallpapers directory exists for wallsetter script
      home.activation.wallpapersDir = hmArgs.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p $HOME/backgrounds
      '';
    };
}
