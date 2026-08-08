{ config, lib, ... }:
{
  flake.modules = {
    nixos.foundation = {
      environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
        ".local/state/wireplumber"
        ".config/pulse"
      ];
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        wireplumber.configPackages = [ ];
      };
      security.rtkit.enable = true;
    };

    homeManager.hyprland =
      { pkgs, ... }:
      let
        wpctl = lib.getExe' pkgs.wireplumber "wpctl";
      in
      {
        home.packages = with pkgs; [
          pwvucontrol
          qpwgraph
        ];

        wayland.windowManager.hyprland.settings.bind = [
          {
            _args = [
              (lib.generators.mkLuaInline ''modifier .. " + M"'')
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON (lib.getExe pkgs.pwvucontrol)})")
            ];
          }
          {
            _args = [
              "XF86AudioRaiseVolume"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"})")
            ];
          }
          {
            _args = [
              "XF86AudioLowerVolume"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"})")
            ];
          }
          {
            _args = [
              "XF86AudioMute"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"})")
            ];
          }
        ];

        xdg.configFile = {
          "wireplumber/wireplumber.conf.d/50-pro-x-profile.conf".text = ''
            monitor.alsa.rules = [
              {
                matches = [
                  { device.name = "alsa_card.usb-Logitech_PRO_X_Wireless_Gaming_Headset-00" }
                ]
                actions = {
                  update-props = {
                    device.profile = "output:analog-stereo+input:mono-fallback"
                  }
                }
              }
            ]
          '';

          "pipewire/pipewire.conf.d/99-quality.conf".text = builtins.toJSON {
            "context.properties" = {
              "default.clock.allowed-rates" = [
                44100
                48000
                96000
              ];
            };
            "stream.properties" = {
              "resample.quality" = 10;
            };
          };
        };
      };
  };
}
