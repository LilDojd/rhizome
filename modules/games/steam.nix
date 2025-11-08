{
  flake.modules.homeManager.base =
    { config, ... }:
    {
      home.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATH = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
    };
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
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
  nixpkgs.allowedUnfreePackages = [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];
}
