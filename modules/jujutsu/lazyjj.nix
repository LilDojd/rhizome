{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.jjui
      ];
      home.shellAliases.lj = "jjui";
    };
}
