{ lib, ... }:

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

    homeManager.base =
      { pkgs, ... }:
      {
        home.packages = lib.optionals pkgs.stdenv.isLinux [
          pkgs.efivar
          pkgs.efibootmgr
        ];
      };
  };
}
