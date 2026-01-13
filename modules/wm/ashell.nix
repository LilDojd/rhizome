{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      stylix.targets.ashell.enable = true;

      wayland.windowManager.hyprland.settings.layerrule = [
        "blur on, match:namespace ashell-main-layer"
        "ignore_alpha 0.3, match:namespace ashell-main-layer"
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
          enable_esc_key = true;

          appearance = {
            scale_factor = 1.3;
          };

          modules = {
            left = [
              "App Launcher"
              "Tray"
              "WindowTitle"
            ];
            center = [ "Workspaces" ];
            right = [
              "SystemInfo"
              [
                "Settings"
                "Clock"
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

          app_launcher_cmd = "rofi-launcher";

          workspaces = {
            visibility_mode = "All";
            enable_workspace_filling = true;
          };

          clock = {
            format = "%a %d %b %I:%M %p";
          };

          # Settings module configuration
          settings = {
            lock_cmd = "hyprlock";
            shutdown_cmd = "shutdown now";
            suspend_cmd = "systemctl suspend";
            hibernate_cmd = "systemctl hibernate";
            reboot_cmd = "systemctl reboot";
            logout_cmd = "hyprctl dispatch exit";
            audio_sinks_more_cmd = "pwvucontrol";
            audio_sources_more_cmd = "pwvucontrol";
            indicators = [
              "IdleInhibitor"
              "Audio"
              "Network"
              "Bluetooth"
              "Battery"
            ];
            battery_format = "IconAndPercentage";
            custom_buttons = [
              {
                label = "⏻";
                cmd = "wlogout";
              }
            ];
          };
        };
      };

      home.packages = with pkgs; [
        wlogout
      ];
    };
}
