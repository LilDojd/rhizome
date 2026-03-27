{ config, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.sunsetr ];

      wayland.windowManager.hyprland.settings.exec-once = [
        "sunsetr"
      ];
    };

  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".config/sunsetr"
    ];
}
