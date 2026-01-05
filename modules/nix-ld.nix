{ inputs, ... }:
{
  # TODO: Remove deal overlay when https://github.com/NixOS/nixpkgs/pull/467392 is in unstable
  nixpkgs.overlays = [
    inputs.nix-alien.overlays.default
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          deal = python-prev.deal.overridePythonAttrs (oldAttrs: rec {
            version = "4.24.6";
            src = prev.fetchFromGitHub {
              owner = "life4";
              repo = "deal";
              tag = version;
              hash = "sha256-nLZ06Xfa9Q+Saf8qPXG1Xo6y6oO6kifhfK/gryZ6q90=";
            };
          });
        })
      ];
    })
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
