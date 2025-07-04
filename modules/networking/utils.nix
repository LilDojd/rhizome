{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = with pkgs; [
      bandwhich
      bind
      curl
      ethtool
      gping
      inetutils
      socat
    ];
  };
}
