let
  filename = "update-flake-lock.yaml";
  filePath = ".github/workflows/${filename}";

  steps = {
    checkout = {
      uses = "actions/checkout@v6";
      "with".submodules = true;
    };
    detsysNixInstaller.uses = "DeterminateSystems/nix-installer-action@main";
  };

  runners = {
    linux.name = "ubuntu-latest";
  };
in
{
  perSystem =
    { pkgs, ... }:
    {
      files.files = [
        {
          path_ = filePath;
          drv = pkgs.writers.writeJSON "gh-actions-workflow-update-flake-lock.yaml" {
            name = "Update flake.lock";
            on = {
              workflow_dispatch = { };
              schedule = [
                { cron = "0 18 * * *"; }
              ];
            };
            permissions = {
              id-token = "write";
              contents = "write";
              issues = "write";
              pull-requests = "write";
            };
            jobs.update = {
              runs-on = runners.linux.name;
              steps = [
                steps.checkout
                steps.detsysNixInstaller
                {
                  uses = "DeterminateSystems/update-flake-lock@main";
                  "with" = {
                    token = "\${{ secrets.GH_TOKEN_FOR_UPDATES }}";
                    pr-title = "chore: update Nix flake inputs";
                    pr-labels = ''
                      dependencies
                      automated
                    '';
                  };
                }
              ];
            };
          };
        }
      ];

      treefmt.settings.global.excludes = [
        filePath
      ];
    };
}
