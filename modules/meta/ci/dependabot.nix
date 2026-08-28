let
  filePath = ".github/dependabot.yml";
in
{
  perSystem =
    { pkgs, ... }:
    {
      files.file.${filePath}.source = pkgs.writers.writeJSON "dependabot.yml" {
        version = 2;
        updates = [
          {
            package-ecosystem = "nix";
            directory = "/";
            schedule.interval = "daily";
            open-pull-requests-limit = 20;
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
