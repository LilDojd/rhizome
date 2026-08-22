{ lib, ... }:
{
  flake.modules.homeManager.hyprland = {
    programs.firefox.profiles.stream-dashboard = {
      id = 2;
      settings = {
        "browser.shell.checkDefaultBrowser" = false;
        "browser.tabs.closeWindowWithLastTab" = false;
      };
    };

    stylix.targets.firefox.profileNames = lib.mkAfter [ "stream-dashboard" ];
  };
}
