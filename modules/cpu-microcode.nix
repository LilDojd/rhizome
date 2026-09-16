{ lib, inputs, ... }:
{
  flake-file.inputs = {
    cpu-microcodes = {
      flake = false;
      url = "github:platomav/CPUMicrocodes";
    };
    ucodenix = {
      url = "github:e-tho/ucodenix";
      inputs.cpu-microcodes.follows = "cpu-microcodes";
    };
  };

  flake.modules.nixos.foundation = nixosArgs: {
    imports = [ inputs.ucodenix.nixosModules.default ];
    boot.kernelParams = lib.optional nixosArgs.config.services.ucodenix.enable "microcode.amd_sha_check=off";
  };
}
