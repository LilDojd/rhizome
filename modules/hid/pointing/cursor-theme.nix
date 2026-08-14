{ lib, ... }:
let
  polyModule =
    { pkgs, ... }:
    {
      stylix.cursor = lib.mkDefault {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };

in
{
  flake.modules = {
    nixos.foundation = polyModule;
    homeManager.gui = { pkgs, ... }: {
      imports = [ polyModule ];
      home.pointerCursor.enable = pkgs.stdenv.hostPlatform.isLinux;
    };
    homeManager.hyprland.wayland.windowManager.hyprland.settings.config.cursor = {
      sync_gsettings_theme = true;
      no_hardware_cursors = 2; # change to 1 if want to disable
      enable_hyprcursor = false;
      warp_on_change_workspace = 2;
      no_warps = true;
    };
  };
}
