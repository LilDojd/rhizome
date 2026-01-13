{ inputs, ... }:
{
  flake.modules = {
    homeManager.hyprland = {
      imports = [ inputs.steam-config-nix.homeModules.default ];
      programs.steam.config = {
        enable = true;
        closeSteam = true;

        # Configuration for apps across all users
        apps = {
          dota2 = {
            id = 570;
            compatTool = "steamlinuxruntime_sniper";
            launchOptions = "LD_PRELOAD='' gamemoderun %command%";
          };
        };
        apps = {
          readyornot = {
            id = 1144200;
            compatTool = "GE-Proton";
            launchOptions = "gamemoderun %command%";
          };
        };
      };
    };

  };
}
