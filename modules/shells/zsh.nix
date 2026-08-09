{ lib, config, ... }:
{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
      environment.persistence."/persistent".users.${config.flake.meta.owner.username} = {
        directories = [
          ".cache/zsh"
        ];
        files = [
          ".temp.zsh"
        ];
      };
    };

  flake.modules.homeManager.base =
    homeArgs@{ pkgs, ... }:
    let
      fish = lib.getExe homeArgs.config.programs.fish.package;

      psCommand =
        if pkgs.stdenv.isDarwin then
          "/bin/ps -p $PPID -o comm="
        else
          "${lib.getExe' homeArgs.pkgs.procps "ps"} --no-header --pid=$PPID --format=comm";

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
        dotDir = homeArgs.config.home.homeDirectory;
      };
    };
}
