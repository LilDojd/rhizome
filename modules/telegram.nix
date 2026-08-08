{ config, lib, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".local/share/TelegramDesktop"
      ".local/share/materialgram"
      ".cache/stylix-telegram-theme"
    ];
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.telegram-desktop ];
    };

  flake.modules.homeManager.hyprland.wayland.windowManager.hyprland.settings.window_rule =
    lib.mkBefore
      [
        {
          match.class = "^(org\\.telegram\\.desktop)$";
          tag = "+im";
        }
      ];
}
