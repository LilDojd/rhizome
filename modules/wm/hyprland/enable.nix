{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland.enable = if pkgs.stdenv.isLinux then true else false;
    };
}
