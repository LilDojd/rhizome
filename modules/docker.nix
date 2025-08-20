{
  flake.modules.nixos.foundation = {
    hardware.nvidia-container-toolkit.enable = true;
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
}
