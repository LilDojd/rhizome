{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  gitignore = [
    "/.pre-commit-config.yaml"
  ];

  perSystem =
    { config, ... }:
    {
      devshells.default = {
        devshell.startup.pre-commit.text = config.pre-commit.installationScript;
      };
      pre-commit.check.enable = false;
    };
}
