{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.wlogout ];
      programs.ashell.settings.settings.CustomButton = [
        {
          name = "Power";
          icon = "⏻";
          command = lib.getExe pkgs.wlogout;
        }
      ];
    };
}
