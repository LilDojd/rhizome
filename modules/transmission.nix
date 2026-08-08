{ config, lib, ... }:
{
  flake.modules.nixos.foundation = {
    environment.persistence."/persistent".directories = [
      "/var/lib/transmission"
    ];
    services.transmission = {
      enable = true;
      openPeerPorts = true;
      user = config.flake.meta.owner.username;
      group = "users";
      settings.download-dir = "/home/${config.flake.meta.owner.username}/Downloads";
    };
  };
  flake.modules.homeManager.linux =
    { pkgs, ... }:
    let
      transmission = pkgs.writeShellApplication {
        name = "transmission";
        runtimeInputs = [ pkgs.xdg-utils ];
        text = ''
          xdg-open http://localhost:9091
        '';
      };
    in
    {
      home.packages = [ transmission ];
      xdg.desktopEntries.transmission = {
        name = "Transmission";
        genericName = "BitTorrent Client";
        exec = lib.getExe transmission;
        terminal = false;
        categories = [
          "Network"
          "P2P"
        ];
        icon = "transmission";
        type = "Application";
      };
    };
}
