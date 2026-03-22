{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    { pkgs, ... }:
    {
      devshells.default = {
        packages = [ pkgs.gnupg ];
        commands = [
          {
            name = "update";
            command = ''
              echo "=> Updating flake inputs"
              nix flake update

              jj commit flake.lock -m "flake.lock: Update"
              jj bookmark set master --revision "@-"
              jj git push
            '';
          }
        ];
      };
    };
}
