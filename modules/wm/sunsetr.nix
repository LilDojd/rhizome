{ config, ... }:
{
  flake.modules.homeManager.hyprland =
    { lib, pkgs, ... }:
    {
      home.packages = [ pkgs.sunsetr ];

      wayland.windowManager.hyprland.settings.on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''function() hl.exec_cmd("sunsetr") end'')
          ];
        }
      ];
    };

  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".config/sunsetr"
    ];
}
