{ config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".config/Proton"
    ];
  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.protonvpn-gui ];
    };
}
