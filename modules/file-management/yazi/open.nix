{ lib, ... }:
{
  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      programs.yazi.settings = {
        opener = {
          open = lib.mkBefore [
            {
              run = "${lib.getExe' pkgs.xdg-utils "xdg-open"} %s1";
              desc = "Open";
              for = "linux";
            }
          ];
          reveal = lib.mkBefore [
            {
              run = "${lib.getExe' pkgs.xdg-utils "xdg-open"} %d1";
              desc = "Reveal";
              for = "linux";
            }
          ];
        };
        open.append_rules = [
          {
            mime = "*";
            use = "open";
          }
        ];
      };
    };
}
