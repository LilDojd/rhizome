{ withSystem, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        devenv = pkgs.devenv;
      };
    };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = withSystem pkgs.system (psArgs: with psArgs.config.packages; [ devenv ]);
    };
}
