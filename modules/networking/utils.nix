{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bandwhich
        bind
        curl
        gping
        inetutils
        socat
      ];
    };

  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ethtool
      ];
    };
}
