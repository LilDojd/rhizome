{
  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ pciutils ];
    };
}
