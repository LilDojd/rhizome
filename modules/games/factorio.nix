{ config, ... }:
{
  flake.modules.homeManager.hyprland.programs.steam.config.apps."427520" = {
    name = "factorio";
    rawLaunchOptions = "gamemoderun %command%";
  };
  flake.modules.nixos.foundation = {
    environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
      ".factorio"
    ];
  };
}
