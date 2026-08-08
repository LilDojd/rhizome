{
  flake.modules.homeManager.hyprland =
    { ... }:
    {
      stylix.targets.ashell.enable = true;

      systemd.user.services.ashell.Service.Environment = [ "WGPU_BACKEND=gl" ];

      wayland.windowManager.hyprland.settings.layer_rule = [
        {
          match.namespace = "ashell-main-layer";
          blur = true;
        }
        {
          match.namespace = "ashell-main-layer";
          ignore_alpha = 0.3;
        }
      ];

      programs.ashell = {
        enable = true;
        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
        settings = {
          outputs = "All";
          position = "Top";
          region = "en-GB";
          enable_esc_key = true;

          appearance = {
            scale_factor = 1.3;
          };

          modules = {
            left = [
              "AppLauncher"
              "Clipboard"
              "Tray"
              "WindowTitle"
            ];
            center = [ "Workspaces" ];
            right = [
              "SystemInfo"
              [
                "Settings"
                "Tempo"
              ]
            ];
          };

          system_info = {
            indicators = [
              "Cpu"
              "Memory"
              "Temperature"
            ];
            temperature.sensor = "k10temp Tctl";
          };

          workspaces = {
            visibility_mode = "All";
            enable_workspace_filling = true;
          };

          tempo = {
            clock_format = "%a %d %b %I:%M %p";
          };

          # Settings module configuration
          settings = {
            shutdown_cmd = "shutdown now";
            suspend_cmd = "systemctl suspend";
            hibernate_cmd = "systemctl hibernate";
            reboot_cmd = "systemctl reboot";
            logout_cmd = "hyprctl dispatch exit";
            indicators = [
              "IdleInhibitor"
              "Audio"
              "Microphone"
              "Brightness"
              "Network"
              "Bluetooth"
              "Battery"
            ];
            battery_format = "IconAndPercentage";
          };
        };
      };
    };
}
