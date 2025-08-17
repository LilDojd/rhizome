{
  flake.modules.nixos.foundation = {
    boot = {
      kernelParams = [
        "pcie_port_pm=off"
        "pcie_aspm.policy=performance"
      ];
    };
  };
}
