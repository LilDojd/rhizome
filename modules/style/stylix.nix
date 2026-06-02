{ inputs, ... }:
{
  flake.modules = {
    nixos.foundation = {
      imports = [ inputs.stylix.nixosModules.stylix ];
      stylix = {
        enable = true;
        homeManagerIntegration.autoImport = false;
        targets.kmscon.enable = false;
        # TODO: https://github.com/nix-community/stylix/issues/2325
        enableReleaseChecks = false;
      };
    };

    darwin.foundation = {
      imports = [ inputs.stylix.darwinModules.stylix ];
      stylix = {
        enable = true;
        homeManagerIntegration.autoImport = false;
        # TODO: https://github.com/nix-community/stylix/issues/2325
        enableReleaseChecks = false;
      };
    };

    homeManager.base = {
      imports = [ inputs.stylix.homeModules.stylix ];
      stylix.enable = true;
      stylix.overlays.enable = false;
      # TODO: https://github.com/nix-community/stylix/issues/2325
      stylix.enableReleaseChecks = false;
    };

  };
}
