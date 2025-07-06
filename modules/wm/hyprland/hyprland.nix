{
  lib,
  ...
}:
{
  flake.modules.homeManager.hyprland =
    hmArgs@{ pkgs, ... }:
    {
      home.packages = with pkgs; [
        grim
        slurp
        wl-clipboard
        swappy
        ydotool
        hyprpolkitagent
        hyprland-qtutils # needed for banners and ANR messages
      ];

      systemd.user.targets.hyprland-session.Unit.Wants = [
        "xdg-desktop-autostart.target"
      ];

      wayland.windowManager.hyprland = {
        systemd = {
          enable = true;
          enableXdgAutostart = true;
          variables = [ "--all" ];
        };
        xwayland = {
          enable = true;
        };

        extraConfig = ''
          xwayland {
            force_zero_scaling = true
          }
        '';

        settings = {

          input = {
            numlock_by_default = true;
            follow_mouse = 1;
            float_switch_override_focus = 0;
            sensitivity = 0;
            touchpad = {
              natural_scroll = true;
              disable_while_typing = true;
              scroll_factor = 0.8;
            };
          };

          debug.disable_logs = false;

          gestures = {
            workspace_swipe = 1;
            workspace_swipe_fingers = 3;
            workspace_swipe_distance = 500;
            workspace_swipe_invert = 1;
            workspace_swipe_min_speed_to_force = 30;
            workspace_swipe_cancel_ratio = 0.5;
            workspace_swipe_create_new = 1;
            workspace_swipe_forever = 1;
          };

          general = {
            "$modifier" = "SUPER";
            layout = "dwindle";
            "col.active_border" =
              lib.mkForce "rgb(${hmArgs.config.lib.stylix.colors.base08}) rgb(${hmArgs.config.lib.stylix.colors.base0C}) 45deg";
            "col.inactive_border" = lib.mkForce "rgb(${hmArgs.config.lib.stylix.colors.base01})";
          };

          misc = {
            layers_hog_keyboard_focus = true;
            initial_workspace_tracking = 0;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = false;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            enable_swallow = false;
            vfr = true; # Variable Frame Rate
            vrr = 0; # Variable Refresh Rate  Might need to set to 0 for NVIDIA/AQ_DRM_DEVICES
            # Screen flashing to black momentarily or going black when app is fullscreen
            # Try setting vrr to 0

            #  Application not responding (ANR) settings
            enable_anr_dialog = true;
            anr_missed_pings = 20;
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
            force_split = 2;
          };

          decoration = {
            rounding = 10;
            blur = {
              enabled = true;
              size = 5;
              passes = 3;
              ignore_opacity = false;
              new_optimizations = true;
            };
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = lib.mkForce "rgba(1a1a1aee)";
            };
          };

          ecosystem = {
            no_donation_nag = true;
            no_update_news = false;
          };

          cursor = {
            sync_gsettings_theme = true;
            no_hardware_cursors = 2; # change to 1 if want to disable
            enable_hyprcursor = false;
            warp_on_change_workspace = 2;
            no_warps = true;
          };

          render = {
            explicit_sync = 1; # Change to 1 to disable
            explicit_sync_kms = 1;
            direct_scanout = 0;
          };

          master = {
            new_status = "master";
            new_on_top = 1;
            mfact = 0.5;
          };
        };
      };
    };
}
