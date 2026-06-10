{ inputs, config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".mozilla"
    ];
  nixpkgs.config.allowUnfreePackages = [
    "firefox-bin"
    "firefox-bin-unwrapped"
    "onepassword-password-manager"
  ];
  nixpkgs.overlays = [ inputs.firefox-addons.overlays.default ];

  flake.modules.darwin.foundation = {
    config.homebrew.casks = [ "firefox" ];
  };
  flake.modules.homeManager.gui =
    { lib, pkgs, ... }:
    let
      plugins = pkgs.firefox-addons;
    in
    {
      programs.firefox = {
        enable = true;
        configPath = lib.mkIf pkgs.stdenv.isLinux ".mozilla/firefox";
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
              onepassword-password-manager
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
