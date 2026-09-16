{
  flake.modules.homeManager.base =
    hmArgs@{ pkgs, ... }:
    {
      home.packages = with pkgs; [
        nix-output-monitor
        nix-fast-build
        nix-tree
        nix-inspect
        nix-melt
        nvd
        nix-diff
      ];
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 2";
        flake = "${hmArgs.config.home.homeDirectory}/rhizome";
      };
    };
}
