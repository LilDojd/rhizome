{
  flake.modules.nixos."nixosConfigurations/darkforest" = {
    networking.wireless.iwd.settings = {
      General.Country = "AE";
      DriverQuirks.PowerSaveDisable = "mt7925e";
    };

    # Keep selective acknowledgements for TCP loss recovery on WAN and Wi-Fi links.
    nix-mineral.settings.network.tcp-sack = true;
  };
}
