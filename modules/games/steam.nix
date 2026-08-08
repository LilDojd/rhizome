{ config, lib, ... }:
{
  flake.modules.homeManager.hyprland.wayland.windowManager.hyprland.settings.window_rule =
    lib.mkBefore
      [
        {
          match.class = "^(gamescope)$";
          tag = "+games";
        }
        {
          match.class = "^(steam_app_[0-9]+)$";
          tag = "+games";
        }
        {
          match.class = "^([Ss]team)$";
          tag = "+gamestore";
        }
        {
          match.class = "^([Ss]team)$";
          match.title = "negative:^([Ss]team)$";
          float = true;
        }
      ];

  flake.modules.homeManager.base =
    { config, ... }:
    {
      home.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATH = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
    };
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
        ".local/share/Steam"
        ".steam"
      ];
      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
      programs.gamemode.enable = true;
      environment.systemPackages = with pkgs; [
        mangohud
        protonup-ng
      ];
    };
  nixpkgs.config.allowUnfreePackages = [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];
}
