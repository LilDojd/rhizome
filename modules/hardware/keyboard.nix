{
  flake.modules = {
    nixos.foundation =
      { pkgs, ... }:
      {
        hardware.keyboard.qmk.enable = true;

        environment.systemPackages = with pkgs; [ vial ];
        services.udev.packages = with pkgs; [
          qmk
          qmk-udev-rules
          qmk_hid
          vial
        ];
      };
  };
}
