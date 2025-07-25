{ config, inputs, ... }:
{
  flake.modules.nixos.foundation = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs.hasGlobalPkgs = true;
      # https://github.com/nix-community/home-manager/issues/6770
      #useUserPackages = true;

      users.${config.flake.meta.owner.username}.imports = [
        (
          { osConfig, ... }:
          {
            home.stateVersion = osConfig.system.stateVersion;
          }
        )
        config.flake.modules.homeManager.base
        config.flake.modules.homeManager.gui or { }
        config.flake.modules.homeManager.hyprland or { }
        config.flake.modules.homeManager.linux or { }
      ];
    };
  };
}
