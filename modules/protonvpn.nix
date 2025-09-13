{
  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.protonvpn-gui ];
    };
}
