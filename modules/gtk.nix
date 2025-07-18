{
  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      wayland.windowManager.sway.wrapperFeatures.gtk = true;
      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.dracula-icon-theme;
          name = "Dracula";
        };
      };
    };
}
