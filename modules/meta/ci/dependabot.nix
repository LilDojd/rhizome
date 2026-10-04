let
  filePath = ".github/dependabot.yml";
in
{
  partitions.dev.module.perSystem =
    { pkgs, ... }:
    {
      files.file.${filePath}.source = pkgs.writers.writeJSON "dependabot.yml" {
        version = 2;
        updates = [
          {
            package-ecosystem = "nix";
            directory = "/";
            schedule.interval = "daily";
            cooldown.default-days = 0;
            open-pull-requests-limit = 1;
            groups.nix-inputs.patterns = [ "*" ];
            labels = [
              "dependencies"
              "automated"
            ];
            commit-message.prefix = "chore(deps)";
          }
        ];
      };

      treefmt.settings.global.excludes = [
        filePath
      ];
    };
}
