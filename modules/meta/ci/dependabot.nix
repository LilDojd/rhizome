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
            labels = [
              "dependencies"
              "automated"
            ];
            commit-message.prefix = "chore";
          }
        ];
      };

      treefmt.settings.global.excludes = [
        filePath
      ];
    };
}
