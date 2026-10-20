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
    let
      python3 = pkgs.python3.override {
        packageOverrides = _: previous: {
          deal = previous.deal.overridePythonAttrs (old: {
            # shortcut: docstring-parser omits test fixtures; remove when deal no longer collects them.
            disabledTestPaths = old.disabledTestPaths ++ [
              "tests/test_linter/test_extractors/test_exceptions.py"
            ];
          });
        };
      };
    in
    {
      environment.systemPackages = [
        (pkgs.nix-alien.override { inherit python3; })
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
