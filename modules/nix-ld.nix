{ inputs, ... }:
{
  flake-file.inputs.nix-alien = {
    url = "github:thiagokokada/nix-alien";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      nix-index-database.follows = "nix-index-database";
      flake-compat.follows = "dedupe_flake-compat";
    };
  };

  nixpkgs.overlays = [
    inputs.nix-alien.overlays.default
  ];

  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = with inputs.nix-alien.packages."x86_64-linux"; [
        nix-alien
      ];
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries =
        with pkgs;
        [
          fuse
          libbsd
          curl
        ]
        ++ (appimageTools.defaultFhsEnvArgs.targetPkgs pkgs)
        ++ (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs);
    };
}
