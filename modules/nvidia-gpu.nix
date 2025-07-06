{ config, ... }:
{
  flake.modules.nixos.nvidia-gpu = {
    specialisation.nvidia-gpu.configuration = {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };
    };
  };
  nixpkgs.allowedUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
  ];
}
