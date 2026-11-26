{ inputs, ... }:
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
      nur.follows = "dedupe_nur";
      systems.follows = "systems";
      tinted-schemes.follows = "tinted-schemes";
    };
  };

  flake.modules = {
    nixos.foundation = {
      imports = [ inputs.stylix.nixosModules.stylix ];
      stylix = {
        enable = true;
        homeManagerIntegration.autoImport = false;
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
