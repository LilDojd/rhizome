{
  inputs,
  ...
}:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      stylix.targets.ashell.enable = true;

      wayland.windowManager.hyprland.settings.layerrule = [
        "blur on, match:namespace ashell-main-layer"
        "ignore_alpha 0.3, match:namespace ashell-main-layer"
      ];

      # TODO: remove package override once https://github.com/NixOS/nixpkgs/pull/504175 is merged
      programs.ashell = {
        enable = true;
        package = inputs.ashell.packages.${pkgs.stdenv.hostPlatform.system}.default;
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

          CustomModule = [
            {
              name = "AppLauncher";
              icon = "󱗼";
              command = "rofi-launcher";
            }
            {
              name = "Clipboard";
              icon = "󰅍";
              command = "kitty --class 'clipse' -e clipse";
            }
          ];

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
              "Microphone"
              "Brightness"
              "Network"
              "Bluetooth"
              "Battery"
            ];
            battery_format = "IconAndPercentage";
            CustomButton = [
              {
                name = "Power";
                icon = "⏻";
                command = "wlogout";
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
