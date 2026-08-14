{ config, inputs, ... }:
let
  mkSlopModule = module: {
    imports = [ module ];
    dendriticSlop = {
      enable = true;
      username = config.flake.meta.owner.username;
      migrations.globalSkills.takeOver = true;
    };
  };
in
{
  flake.modules.nixos.slop = mkSlopModule inputs.dendritic-slop.modules.nixos.slop;
  flake.modules.darwin.slop = mkSlopModule inputs.dendritic-slop.modules.darwin.slop;
}
