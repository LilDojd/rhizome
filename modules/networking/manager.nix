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
        useDHCP = false;
        dhcpcd.enable = false;
        nameservers = [
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
          "8.8.4.4"
        ];
        networkmanager = {
          wifi.backend = "iwd";
          enable = true;
          dns = "none";
        };
      };
    };

    homeManager.linux =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.impala ];
      };
  };
}
