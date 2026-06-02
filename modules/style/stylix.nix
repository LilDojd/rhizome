{ inputs, ... }:
{
  flake.modules = {
    nixos.foundation = {
      imports = [ inputs.stylix.nixosModules.stylix ];
      stylix = {
        enable = true;
        homeManagerIntegration.autoImport = false;
        # stylix's kmscon target still sets services.kmscon.{extraConfig,fonts},
        # which were removed from nixpkgs; we don't use kmscon anyway.
        targets.kmscon.enable = false;
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
