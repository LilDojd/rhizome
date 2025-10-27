{ inputs, ... }:
{
  flake.modules = {
    homeManager.base =
      { pkgs, ... }:
      {
        home.packages = [
          inputs.presenterm.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];

      };
  };
}
