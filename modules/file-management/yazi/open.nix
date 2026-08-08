{
  flake.modules.homeManager.linux.programs.yazi.settings.open.append_rules = [
    {
      mime = "*";
      use = "open";
    }
  ];
}
