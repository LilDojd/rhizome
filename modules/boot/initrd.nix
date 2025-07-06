{
  flake.modules.nixos.foundation.boot.initrd = {
    systemd.enable = true;
  };
}
