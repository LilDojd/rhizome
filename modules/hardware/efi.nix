{
  flake.modules = {
    nixos.efi.boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
        memtest86.enable = true;
        configurationLimit = 4;
      };
    };

    homeManager.linux =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.efivar
          pkgs.efibootmgr
        ];
      };
  };
}
