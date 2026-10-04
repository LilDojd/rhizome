{
  partitions.dev.module =
    { config, ... }:
    let
      inherit (config.flake.meta) repo;
      filename = "publish.yaml";
      filePath = ".github/workflows/${filename}";

      workflowName = "Publish to FlakeHub";

      steps = {
        checkout = {
          uses = "actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803"; # v6
          "with" = {
            ref = "\${{ github.event.workflow_run.head_sha }}";
            submodules = true;
            persist-credentials = false;
          };
        };
        detsysNix = {
          uses = "DeterminateSystems/determinate-nix-action@4d65ea9cab522b6d9f29a170aed23ededc1b27af"; # v3.23.0
          "with".extra-conf = ''
            extra-experimental-features = pipe-operators
          '';
        };
        flakehubPush = {
          uses = "DeterminateSystems/flakehub-push@e001ee821cdb763ef120c01f1048bfb2f938bb9c";
          "with" = {
            source-revision = "e001ee821cdb763ef120c01f1048bfb2f938bb9c";
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
          files.file.${filePath}.source = pkgs.writers.writeJSON "gh-actions-workflow-publish.yaml" {
            name = workflowName;
            on = {
              workflow_run = {
                workflows = [ "Check" ];
                types = [ "completed" ];
                branches = [ repo.defaultBranch ];
              };
            };
            jobs = {
              flakehub-publish = {
                "if" =
                  "github.event.workflow_run.conclusion == 'success' && github.event.workflow_run.event == 'push' && github.event.workflow_run.head_repository.full_name == github.repository";
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

          treefmt.settings.global.excludes = [
            filePath
          ];
        };
    };
}
