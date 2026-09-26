{ inputs, ... }:
{
  flake.modules.homeManager.slop =
    { pkgs, ... }:
    let
      pluginId = "nathanflurry.jj-workspace";
    in
    {
      dendriticSlop.herdr = {
        enable = true;
        plugins = [
          inputs.dendritic-slop.packages.${pkgs.stdenv.hostPlatform.system}.herdr-plugin-jj-workspace
        ];
        settings.keys.command = [
          {
            key = "prefix+a";
            type = "plugin_action";
            command = "${pluginId}.new-tab";
            description = "New jj workspace in a tab";
          }
          {
            key = "prefix+shift+a";
            type = "plugin_action";
            command = "${pluginId}.new";
            description = "New jj workspace";
          }
          {
            key = "prefix+d";
            type = "plugin_action";
            command = "${pluginId}.remove";
            description = "Remove jj workspace";
          }
        ];
      };
    };
}
