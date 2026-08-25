{ inputs, ... }:
{
  flake.modules = {
    homeManager.hyprland = {
      imports = [ inputs.steam-config-nix.homeModules.default ];
      programs.steam.config = {
        enable = true;
        onSteamRunning = "close";

        apps = {
          "570" = {
            name = "dota2";
            compatTool = "steamlinuxruntime_sniper";
            rawLaunchOptions = "gamemoderun %command% +cl_dota_alt_unit_movetodirection '1'";
          };
          "1144200" = {
            name = "readyornot";
            compatTool = "GE-Proton";
            rawLaunchOptions = "gamemoderun %command%";
          };
          "1422450" = {
            name = "readyornot2";
            compatTool = "GE-Proton10-30";
            rawLaunchOptions = "LD_PRELOAD='' PROTON_ENABLE_WAYLAND=1 gamemoderun gamescope -w 3840 -h 2160 -f --force-grab-cursor --mangoapp -- %command% -novid -nojoy -vulkan";
          };
        };
      };
    };
  };
}
