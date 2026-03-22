{
  flake.modules = {
    nixos.foundation = {
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
      {
        home.packages = with pkgs; [
          pwvucontrol
          qpwgraph
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
