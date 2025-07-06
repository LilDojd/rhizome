{ config, inputs, ... }:
{
  flake.modules.darwin.foundation = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        hasGlobalPkgs = true;
      };

      users.${config.flake.meta.owner.username}.imports = [
        config.flake.modules.homeManager.base
        config.flake.modules.homeManager.gui or { }
      ];
    };
  };
}
