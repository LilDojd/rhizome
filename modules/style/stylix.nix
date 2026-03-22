{ inputs, ... }:
{
  flake.modules = {
    nixos.foundation = {
      imports = [ inputs.stylix.nixosModules.stylix ];
      stylix = {
        enable = true;
        homeManagerIntegration.autoImport = false;
      };
    };

    darwin.foundation = {
      imports = [ inputs.stylix.darwinModules.stylix ];
      stylix = {
        enable = true;
        homeManagerIntegration.autoImport = false;
      };
    };

    homeManager.base = {
      imports = [ inputs.stylix.homeModules.stylix ];
      stylix.enable = true;
      stylix.overlays.enable = false;
    };

  };
}
