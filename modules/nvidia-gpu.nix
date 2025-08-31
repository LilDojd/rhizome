{
  flake.modules.nixos.nvidia-gpu =
    { config, ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };
      nix.settings = {
        extra-substituters = [ "https://cuda-maintainers.cachix.org" ];
        extra-trusted-public-keys = [
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
      };
    };

  nixpkgs.allowedUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
  ];

}
