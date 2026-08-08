{ config, ... }:
let
  username = config.flake.meta.owner.username;
  homeManagerModule = {
    wayland.windowManager.hyprland.settings.env = [
      {
        _args = [
          "LIBVA_DRIVER_NAME"
          "nvidia"
        ];
      }
      {
        _args = [
          "__GLX_VENDOR_LIBRARY_NAME"
          "nvidia"
        ];
      }
    ];
  };
in
{
  flake.modules.homeManager.nvidia-gpu = homeManagerModule;
  flake.modules.nixos.nvidia-gpu =
    { config, ... }:
    {
      home-manager.users.${username}.imports = [ homeManagerModule ];
      environment.persistence."/persistent".users.${username}.directories = [
        ".cache/mesa_shader_cache"
      ];
      boot.initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;
      };
      nix.settings = {
        extra-substituters = [ "https://cuda-maintainers.cachix.org" ];
        extra-trusted-public-keys = [
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
      };
    };

  nixpkgs.config.allowUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
    "nvidia-kernel-modules"
  ];

}
