{ inputs, ... }:
{
  flake.modules.darwin.pc = {
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
