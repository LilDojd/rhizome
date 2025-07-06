
{ config, ... }:
{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      services.dunst.enable = true;
    };
}
