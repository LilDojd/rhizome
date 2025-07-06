{ inputs, ... }:
{
  flake.modules.darwin.foundation = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        hasGlobalPkgs = true;
      };
    };
  };
}
