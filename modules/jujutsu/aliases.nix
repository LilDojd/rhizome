{
  flake.modules.homeManager.base = {
    programs.jujutsu = {
      settings = {

        aliases = {
          pre-commit = [
            "util"
            "exec"
            "--"
            "bash"
            "-c"
            ''
              #!/usr/bin/env bash
              set -euo pipefail
              EMPTY=$(jj log --no-graph -r @ -T 'empty')
              if [ "$EMPTY" = "false" ]
              then
                jj new
              fi
              FROM=$(jj log --no-graph -r "fork_point(trunk() | @)" -T "commit_id")
              TO=$(jj log --no-graph -r "@" -T "commit_id")
              pre-commit run --from="$FROM" --to="$TO" "$@"
            ''
            ""
          ];
        };
      };
    };
  };
}
