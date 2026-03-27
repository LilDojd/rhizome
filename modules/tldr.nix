{ config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".cache/tealdeer"
    ];
  flake.modules.homeManager.base.programs = {
    tealdeer = {
      enable = true;
      settings.display.use_pager = true;
    };
    info.enable = true;
  };
}
