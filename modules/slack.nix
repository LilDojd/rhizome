{ config, ... }:
{
  flake.modules = {
    nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
      [
        ".config/Slack"
      ];
    homeManager.gui =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          slack
        ];

      };
  };
  nixpkgs.config.allowUnfreePackages = [ "slack" ];
}
