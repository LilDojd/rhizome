{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  gitignore = [
    "/.pre-commit-config.yaml"
  ];

  perSystem =
    { config, pkgs, ... }:
    {
      devshells.default = {
        devshell.startup.pre-commit.text = config.pre-commit.installationScript;
        packages = [ config.pre-commit.settings.package ];
      };
      pre-commit = {
        check.enable = false;
        settings.package = pkgs.prek;
      };
    };
}
