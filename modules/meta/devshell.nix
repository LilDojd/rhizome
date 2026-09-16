{ inputs, ... }:
{
  flake-file.inputs.devshell = {
    url = "github:numtide/devshell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    { pkgs, ... }:
    {
      devshells.default = {
        packages = with pkgs; [
          gnupg
          nixd
          nil
          nixfmt
        ];
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
