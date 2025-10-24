{
  flake.modules.homeManager.base.programs = {
    git = {
      settings.diff.algorithm = "histogram";
    };
    difftastic = {
      enable = true;
      options.background = "dark";
    };
  };
}
