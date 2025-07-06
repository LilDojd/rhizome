{
  flake.modules = {
    nixos.foundation = {
      networking = {
        wireless.iwd = {
          enable = true;
          settings = {
            IPv6.Enabled = true;
            Settings.AutoConnect = true;
          };
        };
        networkmanager.wifi.backend = "iwd";
      };
    };

    homeManager.linux =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.impala ];
      };
  };
}
