{
  flake.modules = {
    # to silence stylix warnings with old hm state
    homeManager.base.gtk.gtk4.theme = null;

    homeManager.linux =
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
  };
}
