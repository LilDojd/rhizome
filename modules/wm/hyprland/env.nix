{
  flake.modules.homeManager.hyprland =
    let
      mkEnv = name: value: {
        _args = [
          name
          value
        ];
      };
    in
    {
      wayland.windowManager.hyprland.settings = {
        env = [
          (mkEnv "XDG_CURRENT_DESKTOP" "Hyprland")
          (mkEnv "XDG_SESSION_TYPE" "wayland")
          (mkEnv "XDG_SESSION_DESKTOP" "Hyprland")
          (mkEnv "WLR_NO_HARDWARE_CURSORS" "1")
        ];
      };
    };
}
