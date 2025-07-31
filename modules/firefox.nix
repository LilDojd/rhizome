{ inputs, ... }:
{
  nixpkgs.allowedUnfreePackages = [ "firefox-bin" ];
  flake.modules.homemanager.gui =
    { pkgs, ... }:
    let
      plugins = inputs.firefox-addons.packages.${pkgs.system};
    in
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-bin;
        policies = {
          SanitizeOnShutdown = {
            Cache = false;
            Cookies = false;
            History = false;
            Sessions = false;
            SiteSettings = false;
            Locked = true;
          };
        };
        profiles = {
          default = {
            id = 0;
            settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            settings."browser.ctrlTab.sortByRecentlyUsed" = true;
            settings."browser.tabs.closeWindowWithLastTab" = false;
            userChrome = '''';
            userContent = '''';
            extensions.packages = with plugins; [
              privacy-badger
              vimium
              refined-github
              enhanced-github
              clearurls
              adaptive-tab-bar-colour
            ];
          };

          vpn = {
            id = 1;
          };
        };
      };

      stylix.targets.firefox.profileNames = [
        "default"
        "vpn"
      ];
    };
}
