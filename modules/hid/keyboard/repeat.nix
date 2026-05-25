let
  repeat_delay = 200;
  repeat_rate = 50;
in
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager = {
      sway.config.input."type:keyboard" = {
        repeat_delay = toString repeat_delay;
        repeat_rate = toString repeat_rate;
      };

      hyprland.settings.config.input = { inherit repeat_delay repeat_rate; };
    };
  };
}
