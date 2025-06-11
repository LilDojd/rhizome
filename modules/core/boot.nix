{ pkgs, config, host, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = false;
    loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      gfxmodeBios = "auto";
      memtest86.enable = true;
      extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
      configurationName = "${host}";

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
}
