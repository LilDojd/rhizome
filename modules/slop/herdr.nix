let
  plugin = {
    dendriticSlop.herdr.plugins.jj-workspace.enable = true;
  };
in
{
  flake.modules.nixos.slop = plugin;
  flake.modules.darwin.slop = plugin;
}
