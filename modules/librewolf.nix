{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.firefox-addons = {
    url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  nixpkgs.config.allowUnfreePackages = [ "onepassword-password-manager" ];
  nixpkgs.overlays = [ inputs.firefox-addons.overlays.default ];

  flake.modules.darwin.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.defaultbrowser ];
      system.activationScripts.activateSettings.text = "${lib.getExe pkgs.defaultbrowser} librewolf";
      homebrew.casks = [ "librewolf" ];
    };
  flake.modules.homeManager.gui =
    { config, pkgs, ... }:
    let
      plugins = pkgs.firefox-addons;
      browserFont = "Iosevka Term";
    in
    {
      programs.librewolf = {
        enable = true;
        package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.librewolf else null;
        profiles = lib.mkMerge [
          (lib.genAttrs config.stylix.targets.librewolf.profileNames (_: {
            settings = {
              "extensions.autoDisableScopes" = 0;
              # Keep login cookies and site storage while retaining other shutdown cleanup.
              "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
            };
            extensions.packages = [ plugins.darkreader ];
            extensions.settings."FirefoxColor@mozilla.com".force = true;
            userChrome = ''
              * { font-family: "${browserFont}" !important; }
            '';
            userContent = ''
              @-moz-document url-prefix("about:") {
                * { font-family: "${browserFont}" !important; }
              }
              @-moz-document regexp("^moz-extension://[^/]+/sidebar/sidebar[.]html$") {
                #root.root {
                  --general-font-family: "${browserFont}" !important;
                  --tabs-font: 16px var(--general-font-family) !important;
                  --tabs-count-font: 16px var(--general-font-family) !important;
                }
              }
            '';
          }))
          {
            default = {
              id = 0;
              settings = {
                "browser.ctrlTab.sortByRecentlyUsed" = true;
                "browser.tabs.closeWindowWithLastTab" = false;
                "browser.startup.page" = 3;
              }
              // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
                # Keep macOS window controls outside the hidden tab toolbar.
                "browser.tabs.inTitlebar" = 0;
              };
              userChrome = ''
                /* Keep native tabs available until Sidebery is opened. */
                #main-window:has(#sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"]:not([hidden])) #TabsToolbar {
                  display: none !important;
                }
                #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"] {
                  padding-inline-start: 0 !important;
                }
                #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"] :is(#sidebar-header, #sidebar-panel-header) {
                  display: none !important;
                }
                * { border-radius: 0 !important; }
              '';
              extensions.packages = with plugins; [
                sidebery
                seventv
                refined-github
                onepassword-password-manager
              ];
            };

            vpn = {
              id = 1;
            };
          }
        ];
      };

      home.packages = [ (pkgs.iosevka-bin.override { variant = "SGr-IosevkaTerm"; }) ];

      xdg.mimeApps = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        enable = true;
        defaultApplications = lib.genAttrs [
          "text/html"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ] (_: [ "librewolf.desktop" ]);
      };

      stylix.targets.librewolf = {
        colorTheme.enable = true;
        fonts.override = {
          sansSerif.name = browserFont;
          serif.name = browserFont;
          monospace.name = browserFont;
          sizes.terminal = config.stylix.fonts.sizes.applications;
        };
        profileNames = [
          "default"
          "vpn"
        ];
      };
    };

  flake.modules.homeManager.hyprland = hmArgs: {
    wayland.windowManager.hyprland.settings = {
      env = [
        {
          _args = [
            "MOZ_ENABLE_WAYLAND"
            "1"
          ];
        }
      ];
      bind = [
        {
          _args = [
            (lib.generators.mkLuaInline ''modifier .. " + W"'')
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON (lib.getExe hmArgs.config.programs.librewolf.finalPackage)})")
          ];
        }
      ];
      window_rule = lib.mkBefore [
        {
          match.class = "^(librewolf)$";
          tag = "+browser";
        }
      ];
    };
  };
}
