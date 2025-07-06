{
  flake.modules.nixos.foundation = {
    stylix.targets.grub.enable = true;

    boot = {
      kernelParams = [
        "quiet"
        "systemd.show_status=error"
      ];
      plymouth.enable = true;
    };
  };
}
