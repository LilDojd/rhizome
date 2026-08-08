{ config, lib, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".local/state/mpv"
    ];
  flake.modules.homeManager.linux =
    { pkgs, ... }:
    let
      mpv-wayland = pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          uosc
          sponsorblock
        ];

      };
    in
    {
      programs.mpv = {
        enable = true;

        package = mpv-wayland;

        config = {
          gpu-context = "wayland";
          profile = "high-quality";
          ytdl-format = "bestvideo+bestaudio";
          cache-default = 4000000;
        };
      };
    };

  flake.modules.homeManager.hyprland.wayland.windowManager.hyprland.settings.window_rule =
    lib.mkBefore
      [
        {
          match.class = "^(mpv)$";
          float = true;
        }
      ];
}
