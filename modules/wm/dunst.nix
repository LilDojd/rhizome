
{ config, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      services.dunst.enable = true;
    };
}
