{
  nixpkgs.allowedUnfreePackages = [ "via" ];
  flake.modules = {
    nixos.foundation =
      { pkgs, ... }:
      {
        hardware.keyboard.qmk.enable = true;

        environment.systemPackages = with pkgs; [
          vial
          via
          qmk
          qmk-udev-rules
        ];
        services.udev.packages = with pkgs; [
          qmk
          qmk-udev-rules
          qmk_hid
          vial
          via
        ];
      };
    darwin.foundation.config.homebrew.casks = [ "vial" ];
  };
}
