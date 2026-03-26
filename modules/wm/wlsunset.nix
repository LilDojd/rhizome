{ config, ... }:
{
  flake.modules.homeManager.hyprland.services.wlsunset = {
    enable = false;
    latitude = toString config.location.latitude;
    longitude = toString config.location.longitude;
    temperature.day = 6500;
    temperature.night = 4000;
  };
}
