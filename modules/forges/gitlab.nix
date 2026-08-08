{ config, ... }:
{
  flake = {
    modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
      [ ".config/glab-cli" ];
    modules.homeManager.base =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ glab ];
      };
  };
}
