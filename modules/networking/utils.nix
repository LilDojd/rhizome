{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bandwhich
        bind
        curl
        gping
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
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.iputils ];

      security.wrappers = {
        ping = {
          owner = "root";
          group = "root";
          capabilities = "cap_net_raw+p";
          source = "${pkgs.iputils.out}/bin/ping";
        };
      };
    };
}
