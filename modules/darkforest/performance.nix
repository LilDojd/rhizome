{
  flake.modules.nixos."nixosConfigurations/darkforest" =
    { pkgs, ... }:
    {
      powerManagement.cpuFreqGovernor = "performance";

      services.irqbalance.enable = true;

      environment.systemPackages = with pkgs; [
        iperf3
        lm_sensors
      ];
    };
}
