{ lib, ... }:
{
  flake.modules.homeManager.base =
    hmArgs:

    let
      accent = "#" + hmArgs.config.lib.stylix.colors.base0D;
      foreground = "#" + hmArgs.config.lib.stylix.colors.base05;
      muted = "#" + hmArgs.config.lib.stylix.colors.base03;
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
        defaultOptions = [
          "--margin=1"
          "--layout=reverse"
          "--border=none"
          "--info='hidden'"
          "--header=''"
          "--prompt='/ '"
          "-i"
          "--no-bold"
          "--bind='enter:execute(hx {})'"
          "--preview='bat --style=numbers --color=always --line-range :500 {}'"
          "--preview-window=right:60%:wrap"
        ];
      };
    };
}
