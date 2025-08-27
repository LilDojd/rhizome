{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = {
    devshells.default = {
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
