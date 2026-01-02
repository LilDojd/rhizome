{ inputs, ... }:
{
  flake.modules = {
    nixos.foundation = {
      imports = [ "${inputs.nix-mineral}/nix-mineral.nix" ];
      nix-mineral = {
        enable = true;
        settings = {
          kernel = {
            # if false, may prevent low resource systems from booting.
            busmaster-bit = true;

            # Enable symmetric multithreading and just use default CPU mitigations,
            # to potentially improve performance.
            # DO NOT disable all cpu mitigations,
            cpu-mitigations = "smt-on";

            # Could increase I/O performance on ARM64 systems, with risk.
            iommu-passthrough = true;

            # PTI (Page Table Isolation) may tax performance.
            pti = false;
          };
          system.multilib = true;
          network = {
            ip-forwarding = true;
          };
        };

      };
    };
  };
}
