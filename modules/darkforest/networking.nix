{
  flake.modules.nixos."nixosConfigurations/darkforest" = {
    networking.wireless.iwd.settings = {
      General.Country = "AE";
      DriverQuirks.PowerSaveDisable = "mt7925e";
    };

    # Keep selective acknowledgements for TCP loss recovery on WAN and Wi-Fi links.
    nix-mineral.settings.network.tcp-sack = true;

    boot.kernel.sysctl = {
      "net.core.rmem_max" = 33554432;
      "net.core.wmem_max" = 33554432;

      "net.ipv4.tcp_rmem" = "4096 131072 33554432";
      "net.ipv4.tcp_wmem" = "4096 16384 33554432";
    };
  };
}
