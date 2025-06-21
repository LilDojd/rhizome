{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.lazyjj ];
      home.shellAliases.lj = "lazyjj";
    };
}
