{ inputs, ... }:
{
  flake.modules = {
    nixos.foundation = {
      imports = [ inputs.nix-mineral.nixosModules.nix-mineral ];
      nix-mineral = {
        enable = true;
        preset = "compatibility";
        settings = {
          kernel = {
            # if false, may prevent low resource systems from booting.
            busmaster-bit = true;

            # Enable symmetric multithreading and just use default CPU mitigations,
            # to potentially improve performance.
            # DO NOT disable all cpu mitigations,
            cpu-mitigations = "smt-on";

            # PTI (Page Table Isolation) may tax performance.
            pti = false;
          };
          system.multilib = true;
          network = {
            ip-forwarding = true;
          };
        };
        filesystems = {
          enable = true;
          normal = {
            home = {
              enable = true;
              options.noexec = false;
            };
            tmp = {
              enable = true;
              options.noexec = false;
            };
            var = {
              enable = true;
              options.noexec = false;
            };
          };
        };
      };
    };
  };
}
