{ host, ... }:
let inherit (import ../../../hosts/${host}/variables.nix) MonitorSettings;
in {
  wayland.windowManager.hyprland = {
    extraConfig = ''
      ${MonitorSettings}
    '';
  };
}
