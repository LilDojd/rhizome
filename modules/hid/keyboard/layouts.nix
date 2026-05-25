{
  lib,
  config,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        get-hyprland-main-keyboard-layout = pkgs.writeShellApplication {
          name = "get-hyprland-main-keyboard-layout";
          runtimeInputs = with pkgs; [
            hyprland
            jq
          ];
          text = ''
            hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap | select(. == "English (US)" or . == "Russian") | if . == "English (US)" then "us" else "ru" end'
          '';
        };
      };
    };

  flake.modules.homeManager.hyprland =
    hmArgs@{ pkgs, ... }:
    let
      layout = config.flake.meta.owner.preferences.layout |> lib.concatStringsSep ",";

      hyprlandStateFile = "${hmArgs.config.xdg.stateHome}/hyprland-rotate-kb-layout";

      hyprland-rotate-keyboard-layout = pkgs.writeShellApplication {
        name = "hyprland-rotate-kb-layout";
        runtimeInputs = with pkgs; [ hyprland ];
        text = ''
          hyprctl switchxkblayout main next
          touch "${hyprlandStateFile}"
        '';
      };
    in
    {
      wayland.windowManager = {

        hyprland.settings = {
          bind = [
            {
              _args = [
                "ALT + SHIFT + SHIFT_L"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON (hyprland-rotate-keyboard-layout |> lib.getExe)})")
              ];
            }
          ];
          config.input.kb_layout = layout;
          # Alternative way to switch keyboard layout
          config.input.kb_options = [ "grp:ctrl_space_toggle" ];
        };
      };
    };
}
