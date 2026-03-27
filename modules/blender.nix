{ config, ... }:
{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.blender ];
      environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
        ".config/blender"
      ];
    };
}
