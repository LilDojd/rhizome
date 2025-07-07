{
  flake.modules = {
    nixos.foundation =
      { pkgs, ... }:
      {
        hardware.keyboard.qmk.enable = true;
        nixpkgs.allowedUnfreePackages = [ "via" ];

        environment.systemPackages = with pkgs; [
          vial
          via
        ];
        services.udev.packages = with pkgs; [
          qmk
          qmk-udev-rules
          qmk_hid
          vial
          via
        ];
      };
  };
}
