{
  flake.modules.homeManager.base.programs.git = {

    settings.log.decorate = "full"; # Show branch/tag info in git log
    settings.log.date = "iso"; # ISO 8601 date format
  };
}
