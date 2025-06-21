{ lib, ... }:
{
  flake.modules.homeManager.base =
    homeArgs:
    let
      fish = lib.getExe homeArgs.config.programs.fish.package;
      procps = lib.getExe' homeArgs.pkgs.procps "ps";

      psCommand =
        if homeArgs.pkgs.stdenv.isDarwin then
          "${procps} -p $PPID -o comm="
        else
          "${procps} --no-header --pid=$PPID --format=comm";

      earlyZshInit = lib.mkOrder 1000 ''
        if [[ $(${psCommand}) != "fish" && -z ''${ZSH_EXECUTION_STRING} ]]; then
          [[ -o login ]] && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${fish} $LOGIN_OPTION
        fi
      '';
    in
    {
      programs.zsh = {
        enable = true;
        initContent = lib.mkMerge [ earlyZshInit ];
      };
    };
}
