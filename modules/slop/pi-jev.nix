{ inputs, ... }:
{
  flake.modules.homeManager.slop =
    { pkgs, ... }:
    {
      dendriticSlop.piPackages = [
        inputs.dendritic-slop.packages.${pkgs.stdenv.hostPlatform.system}.pi-jev
      ];
      home.file.".pi/agent/pi-jev.json".source = (pkgs.formats.json { }).generate "pi-jev.json" {
        gate = {
          enabled = true;
          mode = "shadow";
        };
        output.enabled = true;
      };
    };
}
