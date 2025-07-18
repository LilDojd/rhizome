{
  flake.modules.homeManager.base = {
    programs = {
      zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        options = [ "--cmd cd" "--cmd z" ];
      };
    };
  };
}
