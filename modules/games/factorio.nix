{ config, ... }:
{
  flake.modules.homeManager.hyprland.programs.steam.config.apps.factorio = {
    id = 427520;
    launchOptionsStr = "gamemoderun %command%";
  };
  flake.modules.nixos.foundation = {
    environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
      ".factorio"
    ];
  };
}
