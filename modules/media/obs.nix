{ lib, ... }:
{
  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;

        # optional Nvidia hardware acceleration
        package = (
          pkgs.obs-studio.override {
            cudaSupport = true;
          }
        );

        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vaapi # optional AMD hardware acceleration
          obs-gstreamer
          obs-vkcapture
        ];
      };
    };

  flake.modules.homeManager.hyprland = hmArgs: {
    wayland.windowManager.hyprland.settings.bind = [
      {
        _args = [
          (lib.generators.mkLuaInline ''modifier .. " + O"'')
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON (lib.getExe hmArgs.config.programs.obs-studio.package)})")
        ];
      }
    ];
  };
}
