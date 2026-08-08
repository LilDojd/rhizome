{ config, lib, ... }:
{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.blender ];
      environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
        ".config/blender"
      ];
    };

  flake.modules.homeManager.hyprland.wayland.windowManager.hyprland.settings.window_rule =
    lib.mkBefore
      [
        {
          match.class = "^(blender)$";
          suppress_event = "maximize";
        }
        {
          match.class = "^(blender)$";
          no_anim = true;
        }
      ];
}
