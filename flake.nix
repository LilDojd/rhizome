{
  description = "Darkforest flake";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.05";
    tinted-schemes = {
      flake = false;
      url = "github:tinted-theming/schemes";
    };
    agenix.url = "github:ryantm/agenix";
    swww.url =
      "github:LGFae/swww";
    _1password-shell-plugins.url = "github:1Password/shell-plugins";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      host = "darkforest";
      profile = "darkforest";
      username = "yawner";
    in {
      nixosConfigurations = {
        darkforest = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit host;
            inherit profile;
          };
          modules = [ ./profiles/nvidia ];
        };
      };
    };
}
