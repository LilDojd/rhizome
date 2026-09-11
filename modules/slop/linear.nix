let
  mcp = {
    dendriticSlop.mcps.linear.enable = true;
  };
in
{
  flake.modules.nixos.slop = mcp;
  flake.modules.darwin.slop = mcp;
}
