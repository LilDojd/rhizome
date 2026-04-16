{
  flake.modules.nixos.foundation = {
    stylix.targets.grub.enable = false;

    boot = {
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=error"
      ];
      plymouth.enable = true;
    };
  };
}
