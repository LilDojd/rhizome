{ inputs, ... }:
{
  flake.modules = {
    homeManager.hyprland = {
      imports = [ inputs.steam-config-nix.homeModules.default ];
      programs.steam.config = {
        enable = true;
        closeSteam = true;

        apps = {
          factorio = {
            id = 427520;
            launchOptionsStr = "gamemoderun %command%";
          };
          dota2 = {
            id = 570;
            compatTool = "steamlinuxruntime_sniper";
            launchOptionsStr = "gamemoderun %command% +cl_dota_alt_unit_movetodirection '1'";
          };
          readyornot = {
            id = 1144200;
            compatTool = "GE-Proton";
            launchOptionsStr = "gamemoderun %command%";
          };
          readyornot2 = {
            id = 1422450;
            compatTool = "GE-Proton10-30";
            launchOptionsStr = "LD_PRELOAD='' PROTON_ENABLE_WAYLAND=1 gamemoderun gamescope -w 3840 -h 2160 -f --force-grab-cursor --mangoapp -- %command% -novid -nojoy -vulkan";
          };
        };
      };
    };
  };
}
