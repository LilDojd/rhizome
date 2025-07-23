{ inputs, ... }:
let
  system = "x86_64-linux";
in
{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = with inputs.nix-alien.packages.${system}; [
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
