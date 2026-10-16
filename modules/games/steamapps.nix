{ inputs, ... }:
{
  flake-file.inputs.steam-config-nix = {
    url = "github:different-name/steam-config-nix";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      systems.follows = "systems";
    };
  };

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
          "4954910" = {
            name = "scamwithyourfriends";
            compatTool = "proton_experimental";
            # Unity defaults to uncapped native 4K; reduce load and stabilize frame pacing.
            rawLaunchOptions = "MANGOHUD_CONFIG=fps_limit=120 gamemoderun mangohud %command% -screen-fullscreen 1 -screen-width 2560 -screen-height 1440";
          };
        };
      };
    };
  };
}
