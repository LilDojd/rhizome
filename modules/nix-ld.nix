{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nix-alien.overlays.default
  ];

  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = with inputs.nix-alien.packages."x86_64_linux"; [
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
