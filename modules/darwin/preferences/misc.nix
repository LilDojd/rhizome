let
  vars = {
    defaultbrowser = "firefox";
  };
in
{
  flake.modules.darwin.foundation =
    { pkgs, ... }:
    {
      system.defaults = {
        NSGlobalDomain = {
          # disable auto capitalization
          NSAutomaticCapitalizationEnabled = false;

          # disable auto dash substitution
          NSAutomaticDashSubstitutionEnabled = false;

          # disable auto period substitution
          NSAutomaticPeriodSubstitutionEnabled = false;

          # disable auto quote substitusion
          NSAutomaticQuoteSubstitutionEnabled = false;

          # expand save panel by default
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
        };

        CustomUserPreferences = {
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
        };
      };
      environment.systemPackages = (
        if (vars ? "defaultbrowser" && builtins.isString vars.defaultbrowser) then
          [ pkgs.defaultbrowser ]
        else
          [ ]
      );
      system.activationScripts = (
        if (vars ? "defaultbrowser" && builtins.isString vars.defaultbrowser) then
          {
            activateSettings.text = "defaultbrowser ${vars.defaultbrowser}";
          }
        else
          { }
      );
    };
}
