{ inputs, ... }:
{
  flake-file.inputs.nix-mineral = {
    url = "github:cynicsketch/nix-mineral";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules = {
    nixos.foundation = {
      imports = [ inputs.nix-mineral.nixosModules.nix-mineral ];
      nix-mineral = {
        enable = true;
        preset = "compatibility";
        settings = {
          # Boot visuals are managed in boot/visuals.nix, without obsolete initrd options.
          debug.quiet-boot = false;
          kernel = {
            # if false, may prevent low resource systems from booting.
            busmaster-bit = true;

            # Enable symmetric multithreading and just use default CPU mitigations,
            # to potentially improve performance.
            # DO NOT disable all cpu mitigations,
            cpu-mitigations = "smt-on";
          };
          system.multilib = true;
        };
        filesystems = {
          enable = false;
        };
      };
    };
  };
}
