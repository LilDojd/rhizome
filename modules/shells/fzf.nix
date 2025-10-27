{ lib, inputs, ... }:
{
  flake.modules.homeManager.base =
    hmArgs@{ pkgs, ... }:
    let
      accent = "#" + hmArgs.config.lib.stylix.colors.base0D;
      foreground = "#" + hmArgs.config.lib.stylix.colors.base05;
      muted = "#" + hmArgs.config.lib.stylix.colors.base03;
      fzf-preview = inputs.fzf-preview.packages.${pkgs.stdenv.hostPlatform.system}.default;
      binds = [
        "--bind='ctrl-d:preview-down'"
        "--bind='ctrl-u:preview-up'"
        "--bind='ctrl-space:toggle'"
        "--bind='ctrl-s:toggle-sort'"
        "--bind='ctrl-y:yank'"
        "--bind='ctrl-p:change-preview-window(down|hidden|)'"
      ];
      defaultOptions = binds ++ [
        "--height 60%"
        "--info inline-right"
        "--layout=reverse"
        "--marker ▏"
        "--pointer ▌"
        "--prompt '▌ '"
        "--highlight-line"
        "--multi"
        "--color gutter:-1,selected-bg:238,selected-fg:146,current-fg:189"
      ];
      sortFilesCmd = "${lib.getExe pkgs.eza} -s modified -1 --no-quotes --reverse";
    in
    {
      programs.fzf = {
        enable = true;
        enableFishIntegration = true;
        colors = lib.mkForce {
          "fg+" = accent;
          "bg+" = "-1";
          "fg" = foreground;
          "bg" = "-1";
          "prompt" = muted;
          "pointer" = accent;
        };
        inherit defaultOptions;
        defaultCommand = "${lib.getExe pkgs.fd} --type f";
        changeDirWidgetCommand = "${lib.getExe pkgs.fd} --type d";
        fileWidgetCommand = "${lib.getExe pkgs.fd} -t f -X ${sortFilesCmd}";
        fileWidgetOptions = binds ++ [ "--preview='${lib.getExe fzf-preview} {}'" ];
        changeDirWidgetOptions = binds ++ [ "--preview='${lib.getExe pkgs.eza} -T {}'" ];
      };
    };
}
