{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, config, ... }:
    let
      terminal = "ghostty";
    in
    {
      programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        settings = [
          {
            layer = "top";
            position = "top";

            modules-left = [
              "custom/startmenu"
              "tray"
              "hyprland/window"
            ];
            modules-center = [ "hyprland/workspaces" ];
            modules-right = [
              "idle_inhibitor"
              "custom/notification"
              "pulseaudio"
              "battery"
              "clock"
              "custom/exit"
            ];

            "hyprland/workspaces" = {
              format = "{name}";
              format-icons = {
                default = " ";
                active = " ";
                urgent = " ";
              };
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";
            };
            "clock" = {
              format = ''{:%H:%M}'';
              tooltip = true;
              tooltip-format = "<big>{:%A, %d.%B %Y }</big><tt><small>{calendar}</small></tt>";
            };
            "hyprland/window" = {
              max-length = 60;
              separate-outputs = false;
            };
            "memory" = {
              interval = 5;
              format = " {}%";
              tooltip = true;
              on-click = "${terminal} -e btop";
            };
            "cpu" = {
              interval = 5;
              format = " {usage:2}%";
              tooltip = true;
              on-click = "${terminal} -e btop";
            };
            "disk" = {
              format = " {free}";
              tooltip = true;
            };
            "network" = {
              format-icons = [
                "󰤯"
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
              ];
              format-ethernet = " {bandwidthDownBits}";
              format-wifi = " {bandwidthDownBits}";
              format-disconnected = "󰤮";
              tooltip = false;
              on-click = "${terminal} -e btop";
            };
            "tray" = {
              spacing = 12;
            };
            "pulseaudio" = {
              format = "{icon} {volume}% {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted = " {format_source}";
              format-source = " {volume}%";
              format-source-muted = "";
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                  ""
                ];
              };
              on-click = "pavucontrol";
            };
            "custom/exit" = {
              tooltip = false;
              format = "⏻";
              on-click = "sleep 0.1 && wlogout";
            };
            "custom/startmenu" = {
              tooltip = false;
              format = " ";
              on-click = "rofi -show drun";
            };
            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = " ";
                deactivated = " ";
              };
              tooltip = "true";
            };
            "custom/notification" = {
              tooltip = false;
              format = "{icon} {}";
              format-icons = {
                notification = "<span foreground='red'><sup></sup></span>";
                none = "";
                dnd-notification = "<span foreground='red'><sup></sup></span>";
                dnd-none = "";
                inhibited-notification = "<span foreground='red'><sup></sup></span>";
                inhibited-none = "";
                dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
                dnd-inhibited-none = "";
              };
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t";
              escape = true;
            };
            "battery" = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon} {capacity}%";
              format-charging = "󰂄 {capacity}%";
              format-plugged = "󱘖 {capacity}%";
              format-icons = [
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              on-click = "";
              tooltip = false;
            };
          }
        ];
        style = lib.concatStrings [
          ''
            * {
              font-size: 16px;
              font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
              font-weight: bold;
            }
            window#waybar {
              background-color: rgba(26,27,38,0);
              border-bottom: 1px solid rgba(26,27,38,0);
              border-radius: 0px;
              color: #${config.lib.stylix.colors.base0F};
            }
            #workspaces {
              background: linear-gradient(45deg, #${config.lib.stylix.colors.base01}, #${config.lib.stylix.colors.base01});
              margin: 5px;
              padding: 0px 1px;
              border-radius: 15px;
              border: 0px;
              font-style: normal;
              color: #${config.lib.stylix.colors.base00};
            }
            #workspaces button {
              padding: 0px 5px;
              margin: 4px 3px;
              border-radius: 15px;
              border: 0px;
              color: #${config.lib.stylix.colors.base00};
              background: linear-gradient(45deg, #${config.lib.stylix.colors.base0D}, #${config.lib.stylix.colors.base0E});
              opacity: 0.5;
              transition: all 0.3s ease-in-out;
            }
            #workspaces button.active {
              padding: 0px 5px;
              margin: 4px 3px;
              border-radius: 15px;
              border: 0px;
              color: #${config.lib.stylix.colors.base00};
              background: linear-gradient(45deg, #${config.lib.stylix.colors.base0D}, #${config.lib.stylix.colors.base0E});
              opacity: 1.0;
              min-width: 40px;
              transition: all 0.3s ease-in-out;
            }
            #workspaces button:hover {
              border-radius: 15px;
              color: #${config.lib.stylix.colors.base00};
              background: linear-gradient(45deg, #${config.lib.stylix.colors.base0D}, #${config.lib.stylix.colors.base0E});
              opacity: 0.8;
            }
            tooltip {
              background: #${config.lib.stylix.colors.base00};
              border: 1px solid #${config.lib.stylix.colors.base0E};
              border-radius: 10px;
            }
            tooltip label {
              color: #${config.lib.stylix.colors.base07};
            }
            #window {
              margin: 5px;
              padding: 2px 20px;
              color: #${config.lib.stylix.colors.base05};
              background: #${config.lib.stylix.colors.base01};
              border-radius: 15px 15px 15px 15px;
            }
            #memory {
              color: #${config.lib.stylix.colors.base0F};
              background: #${config.lib.stylix.colors.base01};
              margin: 5px;
              padding: 2px 20px;
              border-radius: 15px 15px 15px 15px;
            }
            #clock {
              color: #${config.lib.stylix.colors.base0B};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 15px 15px 15px;
              margin: 5px;
              padding: 2px 20px;
            }
            #idle_inhibitor {
              color: #${config.lib.stylix.colors.base0A};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 15px 15px 15px;
              margin: 3px;
              padding: 2px 20px;
            }
            #cpu {
              color: #${config.lib.stylix.colors.base07};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 15px 15px 15px;
              margin: 5px;
              padding: 2px 20px;
            }
            #disk {
              color: #${config.lib.stylix.colors.base0F};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 15px 15px 15px;
              margin: 5px;
              padding: 2px 20px;
            }
            #battery {
              color: #${config.lib.stylix.colors.base08};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 15px 15px 15px;
              margin: 5px;
              padding: 2px 20px;
            }
            #network {
              color: #${config.lib.stylix.colors.base09};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 15px 15px 15px;
              margin: 5px;
              padding: 2px 20px;
            }
            #tray {
              color: #${config.lib.stylix.colors.base05};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 15px 15px 15px;
              margin: 5px;
              padding: 2px 15px;
            }
            #pulseaudio {
              color: #${config.lib.stylix.colors.base0D};
              background: #${config.lib.stylix.colors.base01};
              margin: 4px;
              padding: 2px 20px;
              border-radius: 15px 15px 15px 15px;
            }
            #custom-notification {
              color: #${config.lib.stylix.colors.base0C};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 15px 15px 15px;
              margin: 5px;
              padding: 2px 20px;
            }
            #custom-startmenu {
              color: #${config.lib.stylix.colors.base0E};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 0px 15px 15px 0px;
              margin: 5px 5px 5px 0px;
              padding: 2px 20px;
            }
            #idle_inhibitor {
              color: #${config.lib.stylix.colors.base09};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 15px 15px 15px;
              margin: 5px;
              padding: 2px 20px;
            }
            #custom-exit {
              color: #${config.lib.stylix.colors.base0E};
              background: #${config.lib.stylix.colors.base00};
              border-radius: 15px 0px 0px 15px;
              margin: 5px 0px 5px 5px;
              padding: 2px 20px;
            }
          ''
        ];
      };

      home.packages = with pkgs; [
        waybar
        swaynotificationcenter
        pavucontrol
        wlogout
      ];
    };
}
