{ host, ... }: {
  imports = [ ../../hosts/${host} ../../modules/drivers ../../modules/core ];
  drivers = {
    # Enable GPU Drivers
    amdgpu.enable = true;
    nvidia.enable = false;
    nvidia-prime.enable = false;
    intel.enable = false;
  };
  vm.guest-services.enable = false;
}
