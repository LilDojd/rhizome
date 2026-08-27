{ lib, config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".local/state/lazygit"
    ];
  flake.modules.homeManager.base =
    hmArgs@{ pkgs, ... }:
    let
      accent = "#${hmArgs.config.lib.stylix.colors.base0D}";
      muted = "#${hmArgs.config.lib.stylix.colors.base03}";
    in
    {

      programs.lazygit = {
        enable = true;
        settings = lib.mkForce {
          disableStartupPopups = true;
          notARepository = "skip";
          promptToReturnFromSubprocess = false;
          update.method = "never";
          git = {
            commit.signOff = true;
            parseEmoji = true;
          };
          gui = {
            theme = {
              activeBorderColor = [
                accent
                "bold"
              ];
              inactiveBorderColor = [ muted ];
            };
            showListFooter = false;
            showRandomTip = false;
            showCommandLog = false;
            showBottomLine = false;
            nerdFontsVersion = "3";
          };
        };
      };
      programs.nhx.settings.keys.normal."space".l.g = [
        ":new"
        ":insert-output ${lib.getExe hmArgs.config.programs.lazygit.package}"
        ":buffer-close!"
        ":redraw"
      ];
      programs.yazi.plugins.lazygit = pkgs.yaziPlugins.lazygit;
      home.shellAliases.lg = "lazygit";
    };
}
