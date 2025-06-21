_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.cachix ];
    };
}
