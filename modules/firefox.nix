{ inputs, ... }:
{
  nixpkgs.config.allowUnfreePackages = [
    "firefox-bin"
    "firefox-bin-unwrapped"
  ];

  flake.modules.darwin.foundation = {
    config.homebrew.casks = [ "firefox" ];
  };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      plugins = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      programs.firefox = {
        enable = true;
        package = if pkgs.stdenv.isLinux then pkgs.firefox-bin else null;
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
            userChrome = "";
            userContent = "";
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
