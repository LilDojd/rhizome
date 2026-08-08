{
  flake.modules.homeManager.base.programs = {
    git = {
      settings.diff.algorithm = "histogram";
    };
  };
}
