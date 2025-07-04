{
  flake.modules = {
    nixos.efi = {
      boot = {
        loader.systemd-boot.enable = false;
        loader.grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = true;
          gfxmodeBios = "auto";
          memtest86.enable = true;

          extraEntries = ''
            menuentry "Reboot" {
              reboot
            }
            menuentry "Shutdown" {
              halt
            }
          '';
        };

        tmp = {
          useTmpfs = false;
          tmpfsSize = "20%";
        };

        loader.efi.canTouchEfiVariables = true;
      };
    };
  };
}
