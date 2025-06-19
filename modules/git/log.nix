{
  flake.modules.homeManager.base.programs.git = {

    extraConfig.log.decorate = "full"; # Show branch/tag info in git log
    extraConfig.log.date = "iso"; # ISO 8601 date format
  };
}
