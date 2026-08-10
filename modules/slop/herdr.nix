{ inputs, ... }:
{
  flake.modules.homeManager.slop =
    { pkgs, ... }:
    {
      home.packages = [ inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.herdr ];
    };
}
