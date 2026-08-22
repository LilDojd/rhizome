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

  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings.window_rule = lib.mkBefore [
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
}
