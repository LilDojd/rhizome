{
  flake.modules.darwin.foundation = {
    config.homebrew.casks = [ "ghostty" ];
  };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;
      };
    };
}
