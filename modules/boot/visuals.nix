{
  flake.modules.nixos.pc = {
    stylix.targets.grub.enable = false;

    boot = {
      kernelParams = [
        "quiet"
        "systemd.show_status=error"
      ];
      plymouth.enable = true;

    };
  };
}
