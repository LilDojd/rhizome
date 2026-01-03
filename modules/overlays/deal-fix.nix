{ ... }:
{
  # Temporary fix for deal package until PR #467392 is merged to unstable
  # https://github.com/NixOS/nixpkgs/pull/467392
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (
          python-final: python-prev: {
            deal = python-prev.deal.overrideAttrs (oldAttrs: rec {
              version = "4.24.6";
              src = oldAttrs.src.override {
                rev = version;
                hash = "sha256-nLZ06Xfa9Q+Saf8qPXG1Xo6y6oO6kifhfK/gryZ6q90=";
              };
            });
          }
        )
      ];
    })
  ];
}
