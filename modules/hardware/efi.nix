{
  flake.modules = {
    nixos.efi.boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
        memtest86.enable = true;
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
