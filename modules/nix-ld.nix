{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nix-alien.overlays.default
  ];

  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.nix-alien
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
