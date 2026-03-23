{ config, ... }:
let
  inherit (config.flake.meta) repo;
  filename = "publish.yaml";
  filePath = ".github/workflows/${filename}";

  workflowName = "Publish to FlakeHub";

  steps = {
    checkout = {
      uses = "actions/checkout@v6";
      "with".persist-credentials = false;
    };
    detsysNix = {
      uses = "DeterminateSystems/determinate-nix-action@v3";
      "with".extra-conf = ''
        extra-experimental-features = pipe-operators
      '';
    };
    flakehubPush = {
      uses = "DeterminateSystems/flakehub-push@main";
      "with" = {
        name = "${repo.owner}/${repo.name}";
        rolling = true;
        visibility = "public";
        include-output-paths = true;
      };
    };
  };
in
{
  perSystem =
    { pkgs, ... }:
    {
      files.files = [
        {
          path_ = filePath;
          drv = pkgs.writers.writeJSON "gh-actions-workflow-publish.yaml" {
            name = workflowName;
            on = {
              workflow_run = {
                workflows = [ "Check" ];
                types = [ "completed" ];
                branches = [ repo.defaultBranch ];
              };
              workflow_dispatch = { };
            };
            jobs = {
              flakehub-publish = {
                "if" =
                  "github.event_name == 'workflow_dispatch' || github.event.workflow_run.conclusion == 'success'";
                runs-on = "ubuntu-latest";
                permissions = {
                  id-token = "write";
                  contents = "read";
                };
                steps = [
                  steps.checkout
                  steps.detsysNix
                  steps.flakehubPush
                ];
              };
            };
          };
        }
      ];

      treefmt.settings.global.excludes = [
        filePath
      ];
    };
}
