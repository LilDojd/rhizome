{ inputs, config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".cache/nix-index"
    ];
  flake.modules.homeManager.base = {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];
    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
    };
  };
}
