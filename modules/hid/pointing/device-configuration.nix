{
  flake.modules = {
    nixos.foundation =
      { pkgs, ... }:
      {
        services.ratbagd.enable = true;
        environment.systemPackages = [ pkgs.piper ];
      };

    homeManager.hyprland.wayland.windowManager.hyprland.settings.config.input = {
      follow_mouse = 1;
      float_switch_override_focus = 0;
      sensitivity = 0;
    };
  };
}
