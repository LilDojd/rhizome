{ config, ... }:
let
  inherit (config.flake.meta) repo;
  filename = "check.yaml";
  filePath = ".github/workflows/${filename}";

  workflowName = "Check";

  ids = {
    jobs = {
      getCheckNames = "get-check-names";
      check = "check";
      flakehubPublish = "flakehub-publish";
    };
    steps.getCheckNames = "get-check-names";
    outputs = {
      jobs.getCheckNames = "checks";
      steps.getCheckNames = "checks";
    };
  };

  matrixParam = "checks";

  nixArgs = "--accept-flake-config";

  runner = {
    name = "ubuntu-latest";
    system = "x86_64-linux";
  };

  steps = {
    nothingButNix = {
      uses = "wimpysworld/nothing-but-nix@main";
      "with" = {
        hatchet-protocol = "holster";
      };
    };
    checkout = {
      uses = "actions/checkout@v4";
      "with".submodules = true;
    };
    detsysNixInstaller.uses = "DeterminateSystems/nix-installer-action@main";
    magicNixCache.uses = "DeterminateSystems/magic-nix-cache-action@main";
    flakehubPush = {
      uses = "DeterminateSystems/flakehub-push@main";
      "with" = {
        name = "${repo.owner}/${repo.name}";
        rolling = true;
        visibility = "public";
      };
    };
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
      See [`modules/meta/ci.nix`](modules/meta/ci.nix).

    '';
  };

  perSystem =
    { pkgs, ... }:
    {
      files.files = [
        {
          path_ = filePath;
          drv = pkgs.writers.writeJSON "gh-actions-workflow-check.yaml" {
            name = workflowName;
            on = {
              push = { };
              workflow_call = { };
            };
            permissions = {
              id-token = "write";
              contents = "read";
            };
            jobs = {
              ${ids.jobs.getCheckNames} = {
                runs-on = runner.name;
                outputs.${ids.outputs.jobs.getCheckNames} =
                  "\${{ steps.${ids.steps.getCheckNames}.outputs.${ids.outputs.steps.getCheckNames} }}";
                steps = [
                  steps.checkout
                  steps.detsysNixInstaller
                  steps.magicNixCache
                  {
                    id = ids.steps.getCheckNames;
                    run = ''
                      checks="$(nix ${nixArgs} eval --json .#checks.${runner.system} --apply builtins.attrNames)"
                      echo "${ids.outputs.steps.getCheckNames}=$checks" >> $GITHUB_OUTPUT
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
                  steps.nothingButNix
                  steps.detsysNixInstaller
                  steps.magicNixCache
                  {
                    run = ''
                      nix ${nixArgs} build '.#checks.${runner.system}."''${{ matrix.${matrixParam} }}"'
                    '';
                  }
                ];
              };

              ${ids.jobs.flakehubPublish} = {
                needs = ids.jobs.check;
                "if" = "github.ref == 'refs/heads/${repo.defaultBranch}'";
                runs-on = runner.name;
                steps = [
                  steps.checkout
                  steps.detsysNixInstaller
                  steps.flakehubPush
                ];
              };
            };
          };
        }
      ];

      treefmt.settings.global.excludes = [ filePath ];
    };
}
