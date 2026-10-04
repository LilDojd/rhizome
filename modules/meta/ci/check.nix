{
  partitions.dev.module =
    { config, ... }:
    let
      inherit (config.flake.meta) repo;
      filename = "check.yaml";
      filePath = ".github/workflows/${filename}";

      workflowName = "Check";

      mkIds = platform: {
        jobs = {
          getCheckNames = "get-check-names-${platform}";
          check = "check-${platform}";
        };
        steps.getCheckNames = "get-check-names";
        outputs = {
          jobs.getCheckNames = "checks";
          steps.getCheckNames = "checks";
        };
      };

      matrixParam = "checks";

      nixArgs = "--accept-flake-config";

      runners = {
        linux = {
          name = "ubuntu-latest";
          system = "x86_64-linux";
        };
        darwin = {
          name = "macos-latest";
          system = "aarch64-darwin";
        };
      };

      steps = {
        nothingButNix = {
          uses = "wimpysworld/nothing-but-nix@baf7355748bb5651f08b839669d6bb39051b2874";
          "with" = {
            hatchet-protocol = "holster";
          };
        };
        checkout = {
          uses = "actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803"; # v6
          "with" = {
            submodules = true;
            persist-credentials = false;
          };
        };
        detsysNixInstaller.uses = "DeterminateSystems/determinate-nix-action@4d65ea9cab522b6d9f29a170aed23ededc1b27af"; # v3.23.0
        flakehubCache.uses = "DeterminateSystems/flakehub-cache-action@88740a21e786360ba66bdd8fecabcbf852db3a5a"; # v3.23.0
      };
    in
    {
      text.readme.parts = {
        ci-badge = ''
          <a href="https://github.com/${repo.owner}/${repo.name}/actions/workflows/${filename}?query=branch%3A${repo.defaultBranch}">
          <img
            alt="CI status"
            src="https://img.shields.io/${repo.forge}/actions/workflow/status/${repo.owner}/${repo.name}/${filename}?style=for-the-badge&branch=${repo.defaultBranch}&label=${workflowName}"
          >
          </a>

        '';
        flakehub = ''
          [![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/${repo.owner}/${repo.name}/badge)](https://flakehub.com/flake/${repo.owner}/${repo.name})

        '';
        github-actions = ''
          ## Running checks on GitHub Actions

          Workflow files are generated using
          [the _files_ flake-parts module](https://github.com/mightyiam/files).
          For better visibility, a job is spawned for each flake check dynamically.

          > [!NOTE]
          > Running this repository's flake checks on GitHub Actions is merely a bonus
          > and possibly more of a liability.

        ''
        + (
          assert steps ? nothingButNix;
          ''
            > [!TIP]
            > To prevent runners from running out of space,
            > the action [Nothing but Nix](https://github.com/marketplace/actions/nothing-but-nix)
            > is used.

          ''
        )
        + ''
          See [`modules/meta/ci/check.nix`](modules/meta/ci/check.nix).

        '';
      };

      perSystem =
        { pkgs, config, ... }:
        {
          files.file.${filePath}.source = pkgs.writers.writeJSON "gh-actions-workflow-check.yaml" {
            name = workflowName;
            on = {
              push.branches = [ repo.defaultBranch ];
              pull_request = { };
              workflow_call = { };
              workflow_dispatch = { };
            };
            concurrency = {
              group = "\${{ github.workflow }}-\${{ github.event_name }}-\${{ github.event.pull_request.number || github.ref }}";
              cancel-in-progress = "\${{ github.event_name == 'pull_request' }}";
            };
            permissions = {
              id-token = "write";
              contents = "read";
            };
            jobs =
              let
                mkJobs =
                  platform: runner:
                  let
                    ids = mkIds platform;
                  in
                  {
                    ${ids.jobs.getCheckNames} = {
                      runs-on = runner.name;
                      outputs.${ids.outputs.jobs.getCheckNames} =
                        "\${{ steps.${ids.steps.getCheckNames}.outputs.${ids.outputs.steps.getCheckNames} }}";
                      steps = [
                        steps.checkout
                        steps.detsysNixInstaller
                        steps.flakehubCache
                        {
                          id = ids.steps.getCheckNames;
                          run = ''
                            checks="$(nix ${nixArgs} eval --json .#checks.${runner.system} --apply builtins.attrNames)"
                            echo "${ids.outputs.steps.getCheckNames}=$checks" >> "$GITHUB_OUTPUT"
                          '';
                        }
                      ];
                    };

                    ${ids.jobs.check} = {
                      needs = ids.jobs.getCheckNames;
                      runs-on = runner.name;
                      strategy = {
                        fail-fast = false;
                        matrix.${matrixParam} =
                          "\${{ fromJson(needs.${ids.jobs.getCheckNames}.outputs.${ids.outputs.jobs.getCheckNames}) }}";
                      };
                      steps = [
                        steps.checkout
                      ]
                      ++ (if platform == "linux" then [ steps.nothingButNix ] else [ ])
                      ++ [
                        steps.detsysNixInstaller
                        steps.flakehubCache
                        {
                          run = ''
                            nix ${nixArgs} build '.#checks.${runner.system}."''${{ matrix.${matrixParam} }}"'
                          '';
                        }
                      ];
                    };
                  };
              in
              (mkJobs "linux" runners.linux)
              // (mkJobs "darwin" runners.darwin)
              // {
                ready = {
                  name = "ready";
                  "if" = "\${{ always() }}";
                  needs = [
                    "get-check-names-linux"
                    "get-check-names-darwin"
                    "check-linux"
                    "check-darwin"
                  ];
                  runs-on = "ubuntu-latest";
                  permissions.contents = "none";
                  steps = [
                    {
                      name = "Require every build job to succeed";
                      env.NEEDS = "\${{ toJSON(needs) }}";
                      run = ''
                        printf '%s\n' "$NEEDS" | jq -e 'length > 0 and all(.[]; .result == "success")'
                      '';
                    }
                  ];
                };
              };
          };

          checks.ci-workflows =
            pkgs.runCommand "ci-workflows-check"
              {
                nativeBuildInputs = [
                  pkgs.actionlint
                  pkgs.jq
                ];
              }
              ''
                actionlint ${config.files.file.${filePath}.source} ${
                  config.files.file.".github/workflows/publish.yaml".source
                }
                jq -r '.jobs.ready.steps[0].run' ${config.files.file.${filePath}.source} > gate.sh
                success=$(jq '.jobs.ready.needs | map({key: ., value: {result: "success"}}) | from_entries' ${
                  config.files.file.${filePath}.source
                })
                NEEDS="$success" bash gate.sh
                if NEEDS='{}' bash gate.sh; then
                  echo "ready incorrectly accepted missing build results" >&2
                  exit 1
                fi
                for job in $(printf '%s\n' "$success" | jq -r 'keys[]'); do
                  for result in failure cancelled skipped; do
                    needs=$(printf '%s\n' "$success" | jq --arg job "$job" --arg result "$result" '.[$job].result = $result')
                    if NEEDS="$needs" bash gate.sh; then
                      echo "ready incorrectly accepted $job: $result" >&2
                      exit 1
                    fi
                  done
                done
                touch "$out"
              '';

          treefmt.settings.global.excludes = [
            filePath
          ];
        };
    };
}
