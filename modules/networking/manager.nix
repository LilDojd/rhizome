{ config, ... }:
{
  flake.modules = {
    nixos.foundation = {
      environment.persistence."/persistent".directories = [
        "/etc/NetworkManager/system-connections"
      ];
      users.users.${config.flake.meta.owner.username}.extraGroups = [ "networkmanager" ];
      networking = {
        wireless.iwd = {
          enable = true;
          settings = {
            IPv6.Enabled = true;
            Settings.AutoConnect = true;
          };

        };
        useDHCP = false;
        dhcpcd.enable = false;
        nameservers = [
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
          "8.8.4.4"
        ];
        networkmanager = {
          wifi.backend = "iwd";
          wifi.powersave = false;
          enable = true;
        };
      };
    };

    homeManager = {
      linux =
        { pkgs, ... }:
        {
          home.packages = [ pkgs.impala ];
        };

      hyprland =
        { lib, pkgs, ... }:
        {
          home.packages = [ pkgs.networkmanagerapplet ];

          xdg.autostart = {
            enable = true;
            entries = [
              "${pkgs.writeTextDir "nm-applet.desktop" ''
                [Desktop Entry]
                Name=NetworkManager Applet
                Comment=Manage your network connections
                Icon=nm-device-wireless
                Exec=${lib.getExe pkgs.networkmanagerapplet} --indicator
                Terminal=false
                Type=Application
                NoDisplay=true
                NotShowIn=KDE;GNOME;COSMIC;
                X-GNOME-UsesNotifications=true
              ''}/nm-applet.desktop"
            ];
          };

          wayland.windowManager.hyprland.settings.window_rule = lib.mkBefore [
            {
              match.class = "^(nm-applet|nm-connection-editor)$";
              tag = "+settings";
            }
          ];
        };
    };
  };
}
