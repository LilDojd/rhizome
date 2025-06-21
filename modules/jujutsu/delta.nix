{ lib, ... }:
{
  flake.modules.homeManager.base =
    homeArgs@{ pkgs, config, ... }:
    let
      deltaPkg = pkgs.delta;
    in
    {
      home.packages = [ deltaPkg ];

      programs.jujutsu.settings.ui.pager = lib.mkIf (builtins.elem deltaPkg config.home.packages) "delta";
    };
}
