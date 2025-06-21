{
  flake.modules.homeManager.base =
    hmArgs@{ pkgs, ... }:
    {
      home.packages = with pkgs; [
        nix-output-monitor
        nix-fast-build
        nix-tree
        nvd
        nix-diff
      ];
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "${hmArgs.config.home.homeDirectory}/rhizome";
      };
    };
}
