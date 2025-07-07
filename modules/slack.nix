{
  flake.modules = {
    homeManager.gui =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          slack
        ];

      };
    homeManager.hyprland = {
      xdg.desktopEntries = {
        slack = {
          name = "Slack";
          genericName = "Slack Client for Linux";
          exec = "slack --use-gl=desktop + --waylandFlags -s %U";
          terminal = false;
          categories = [
            "GNOME"
            "GTK"
            "Network"
            "InstantMessaging"
          ];

          mimeType = [ "x-scheme-handler/slack" ];
          icon = "slack";
          startupNotify = true;
          type = "Application";
        };
      };
    };
  };
  nixpkgs.allowedUnfreePackages = [ "slack" ];
}
