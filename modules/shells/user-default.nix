{ lib, ... }:
{
  flake.modules = {
    nixos.pc =
      { pkgs, ... }:
      {
        programs.bash.enable = true;
        users.defaultUserShell = pkgs.bash;
      };

    darwin.pc =
      { pkgs, ... }:
      {
        user.shell = lib.getExe pkgs.bash;
      };
  };
}
