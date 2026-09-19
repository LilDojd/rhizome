let
  tsk = {
    dendriticSlop = {
      tools.tsk.enable = true;
      skills.tsk-cli.enable = true;
      herdr.plugins.tsk.enable = true;
    };
  };
in
{
  flake.modules.nixos.slop = tsk;
  flake.modules.darwin.slop = tsk;
}
