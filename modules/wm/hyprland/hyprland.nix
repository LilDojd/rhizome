{
  lib,
  inputs,
  ...
}:
{
  flake-file.inputs.hyprland = {
    url = "github:hyprwm/Hyprland/0aa6745f705f2c4b0a5004eb019ef76e5bbdb426"; # v0.57.0
    inputs.systems.follows = "systems";
  };

  flake.modules.nixos.foundation =
    { pkgs, ... }:
    let
      hyprPackages = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      hardware.graphics = {
        package = hyprPackages.mesa;
      };
      programs.hyprland =
        let
          hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          enable = true;
          package = hyprland.hyprland;
          portalPackage = hyprland.xdg-desktop-portal-hyprland;
          withUWSM = false;
        };

      # The pinned portal must not load Qt theme/plugins from the host's newer Qt.
      systemd.user.services.xdg-desktop-portal-hyprland = {
        overrideStrategy = "asDropin";
        serviceConfig.UnsetEnvironment = [
          "QT_PLUGIN_PATH"
          "QT_QPA_PLATFORMTHEME"
          "QT_STYLE_OVERRIDE"
        ];
      };

      hardware.graphics.enable32Bit = lib.mkForce true;
    };
  flake.modules.homeManager.hyprland =
    hmArgs@{ pkgs, ... }:
    {
      imports = [ inputs.hyprland.homeManagerModules.default ];
      home.packages = with pkgs; [
        hyprpolkitagent
      ];

      wayland.windowManager.hyprland = {
        configType = "lua";
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        systemd = {
          enable = true;
          enableXdgAutostart = true;
          variables = [ "--all" ];
        };

        settings.config = {
          general = {
            layout = "dwindle";
            col.active_border = lib.mkForce {
              colors = [
                "rgb(${hmArgs.config.lib.stylix.colors.base08})"
                "rgb(${hmArgs.config.lib.stylix.colors.base0C})"
              ];
              angle = 45;
            };
            col.inactive_border = lib.mkForce "rgb(${hmArgs.config.lib.stylix.colors.base01})";
          };

          layers.layers_hog_keyboard_focus = true;

          misc = {
            initial_workspace_tracking = 0;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = false;
            disable_splash_rendering = true;
            enable_swallow = false;
            vrr = 0; # Variable Refresh Rate  Might need to set to 0 for NVIDIA/AQ_DRM_DEVICES
            # Screen flashing to black momentarily or going black when app is fullscreen
            # Try setting vrr to 0

            #  Application not responding (ANR) settings
            enable_anr_dialog = true;
            anr_missed_pings = 20;
          };

          dwindle = {
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
              color = lib.mkForce (lib.generators.mkLuaInline "0xee1a1a1a");
            };
          };

          render = {
            direct_scanout = 0;
          };

          master = {
            new_status = "master";
            new_on_top = 1;
            mfact = 0.5;
          };

          xwayland = {
            force_zero_scaling = true;
          };
        };
      };
    };
}
