{ lib, ... }:
{
  flake.modules.homeManager.base =
    homeArgs@{ pkgs, ... }:
    let
      fish = lib.getExe homeArgs.config.programs.fish.package;
      procps = lib.getExe' pkgs.procps "ps";
    in
    {
      programs.bash = {
        enable = true;

        initExtra = ''
          if [[ $(${procps} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${fish} $LOGIN_OPTION
          fi
        '';
      };
    };
}
