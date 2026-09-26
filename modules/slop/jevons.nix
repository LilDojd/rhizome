{ inputs, ... }:
{
  flake.modules.homeManager.slop =
    { pkgs, ... }:
    {
      dendriticSlop.piPackages = [
        inputs.dendritic-slop.packages.${pkgs.stdenv.hostPlatform.system}.jevons
      ];
    };
}
