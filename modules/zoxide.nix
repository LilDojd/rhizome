{
  flake.modules.homeManager.base = {
    programs = {
      zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
