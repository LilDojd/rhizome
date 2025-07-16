{ inputs, ... }:
{
  flake.modules = {
    homeManager.base =
      { pkgs, ... }:
      {
        home.packages = [
          inputs.presenterm.packages.${pkgs.system}.default
        ];

      };
  };
}
