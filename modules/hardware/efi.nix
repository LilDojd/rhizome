{
  flake.modules = {
    nixos.efi.boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
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
