{
  flake.modules.nixos.foundation = {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };
}
