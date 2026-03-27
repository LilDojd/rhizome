{ config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".local/share/direnv"
    ];
  flake.modules.homeManager.base = {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        config.global.warn_timeout = 0;
      };
      git.ignores = [
        ".envrc"
        ".direnv"
      ];
    };
  };
}
