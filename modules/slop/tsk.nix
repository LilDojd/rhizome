{ inputs, ... }:
{
  flake.modules.homeManager.slop =
    { pkgs, ... }:
    let
      packages = inputs.dendritic-slop.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      home.packages = [ packages.tsk ];
      dendriticSlop = {
        skills = { inherit (inputs.dendritic-slop.skills) tsk-cli; };
        herdr = {
          plugins = [ packages.herdr-plugin-tsk ];
          settings.keys.command = [
            {
              key = "prefix+t";
              type = "plugin_action";
              command = "herdr-tsk.open-board";
              description = "Open tsk board";
            }
          ];
        };
      };
    };
}
