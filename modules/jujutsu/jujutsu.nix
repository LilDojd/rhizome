{
  lib,
  config,
  ...
}:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".config/jj"
    ];
  flake.modules.homeManager = {
    slop =
      { pkgs, ... }:
      {
        programs.pi.coding-agent.skills = [
          (config.slop.mkSkill {
            inherit pkgs;
            name = "jujutsu";
            text =
              # markdown
              ''
                ---
                name: jujutsu
                description: "REQUIRED: Load this skill before every Git or VCS operation (status, diff, commit, branch/bookmark, merge, rebase, fetch, push, worktree/workspace, or detached HEAD). If .jj exists, use Jujutsu and its native workspaces; avoid mutating Git commands because they can desynchronize colocated state or create divergent changes."
                ---

                # Jujutsu (jj)

                Use Jujutsu's mutable, automatically rebased commits without losing or mixing a user's work.

                **Reviewed against jj 0.44.0.** Start with `jj --version`. If the installed version differs or a flag fails, use `jj --no-pager help <command>` and the [official documentation](https://docs.jj-vcs.dev/latest/) rather than guessing. See the [changelog](https://docs.jj-vcs.dev/latest/changelog/), [CLI reference](https://docs.jj-vcs.dev/latest/cli-reference/), and [working-copy/workspace guide](https://docs.jj-vcs.dev/latest/working-copy/).

                ## Mandatory agent rules

                1. Before any VCS command, detect `.jj` in the repository root or an ancestor. If present, use `jj`, not raw mutating `git` commands.
                2. Put the global `--no-pager` option before the subcommand for output-producing commands:

                   ```bash
                   jj --no-pager status
                   jj --no-pager log
                   jj --no-pager diff --git
                   jj --no-pager show @
                   ```

                3. Never open an editor, diff editor, pager, merge tool, or TUI in an automated session. Supply `-m`, filesets, or other non-interactive arguments. Avoid bare `jj describe`, `jj split`, `jj diffedit`, `jj resolve`, `jj arrange`, and `-i`/`--interactive`.
                4. Inspect before mutating. Do not rewrite, abandon, restore, or squash pre-existing work until its ownership and intent are clear.
                5. After every mutation, run `jj --no-pager status`; inspect `jj --no-pager log -r '...'` when the graph or bookmarks changed.
                6. Fetch and push only when the user requests them or the task explicitly requires them. Always inspect the outgoing revisions/bookmark and use `jj git push --dry-run` before the real push.
                7. Do not use `--ignore-immutable`, `--at-operation`, or `--no-integrate-operation` unless the user specifically needs advanced recovery/concurrency behavior and you have read their current help. `--no-integrate-operation` does not suppress external side effects such as a Git push.

                ## Repository and working-copy model

                - The working copy is a commit named `@`. Most `jj` commands snapshot changed files into it automatically.
                - There is no staging area. New files are normally auto-tracked unless ignored or excluded by `snapshot.auto-track`.
                - `@-` is the parent; `@--` is the grandparent.
                - A **change ID** remains stable across rewrites. A Git-compatible **commit ID** changes when rewritten. Prefer change IDs in commands.
                - Commits are mutable; rewriting one automatically rebases its descendants.
                - Conflicts are first-class commit state, so a rebase can succeed while producing conflicted commits.
                - Bookmarks correspond to Git branches but do not inherently advance when new commits are created. Move/set or advance them deliberately.
                - The operation log records repository mutations and supports undo/redo and recovery.

                Useful revsets:

                | Revset        | Meaning                                         |
                | ------------- | ----------------------------------------------- |
                | `@` / `@-`    | Working-copy commit / its parent                |
                | `::@`         | Ancestors of `@`, including `@`                 |
                | `@::`         | Descendants of `@`, including `@`               |
                | `trunk()..@`  | Commits in the current stack but not in trunk   |
                | `bookmarks()` | Commits targeted by local bookmarks             |
                | `conflicts()` | Conflicted commits                              |
                | `divergent()` | Commits whose change ID has divergent versions  |
                | `mutable()`   | Revisions that current policy permits rewriting |

                String patterns are glob patterns by default in modern jj. Use `exact:`, `glob:`, `substring:`, or `regex:` when ambiguity matters. Hidden or divergent versions of a change can be selected as `CHANGE_ID/0`, `CHANGE_ID/1`, and so on.

                ## Safe task workflow

                ### 1. Inspect the existing state

                ```bash
                jj --version
                jj --no-pager status
                jj --no-pager log -n 12
                jj --no-pager workspace list
                jj --no-pager diff --git
                ```

                Do not assume a detached Git HEAD is an error; colocated jj repositories commonly keep Git HEAD detached.

                ### 2. Choose the working revision

                - If `@` is empty and is the intended task revision, describe it before editing:

                  ```bash
                  jj describe -m "Add user authentication"
                  ```

                - If `@` contains completed work that should remain as its own revision, start an empty child:

                  ```bash
                  jj new -m "Add user authentication"
                  ```

                - If `@` contains unclear, unrelated, or user-owned work, do not rewrite it. Ask what to do or create an isolated native workspace based on an explicit revision.
                - To modify a known existing change, first ensure another workspace is not editing it, then:

                  ```bash
                  jj edit <change-id>
                  ```

                Do not create a redundant empty child at the end of a task. `jj commit -m ...` is available as a describe-and-new convenience, but is unnecessary in this describe-first workflow.

                ### 3. Edit, snapshot, and review

                Make file changes, then:

                ```bash
                jj --no-pager status
                jj --no-pager diff --git
                jj --no-pager show @
                ```

                Use an imperative, sentence-case description with no trailing full stop, such as `Add login endpoint` or `Fix payment retry handling`. Keep one logical change per revision.

                ## Inspecting and navigating

                ```bash
                jj --no-pager log
                jj --no-pager log -p -r 'trunk()..@'
                jj --no-pager show <change-id>
                jj --no-pager diff --git
                jj --no-pager diff --git -r <change-id>
                jj new -m "Next change"
                jj edit <change-id>
                jj prev --edit
                jj next --edit
                ```

                `jj diff` defaults to jj's color-words format. Use `--git` when a unified `+`/`-` patch is easier for the agent to parse; the native format is not corruption.

                ## Refining changes non-interactively

                ### Squash

                A bare `jj squash` can open an editor when source and destination both have descriptions. Select the resulting description explicitly:

                ```bash
                # Move @ into its parent and set the resulting description
                jj squash -m "Final combined description"

                # Preserve the destination description and discard the source description
                jj squash --use-destination-message

                # Move a specific revision into its parent
                jj squash -r <change-id> -m "Final combined description"
                ```

                ### Split by fileset

                Bare `jj split` is interactive. Filesets select the first/selected revision; `-m` prevents a description editor:

                ```bash
                jj split -r <change-id> -m "Extract focused change" path/to/file tests/
                ```

                For hunk-level splitting, do not launch the interactive diff editor. Reorganize changes with explicit filesets or `jj restore --from/--into`, checking the diff after each operation.

                ### Absorb, restore, abandon

                ```bash
                # Distribute @ changes to mutable ancestors that last changed those lines
                jj absorb

                # Replace selected working-copy paths with their parent versions
                jj restore path/to/file

                # Replace all working-copy content with its parent while keeping @ metadata
                jj restore

                # Copy paths from another revision into @
                jj restore --from <change-id> path/to/file

                # Remove a revision and rebase descendants onto its parents
                jj abandon <change-id>
                ```

                `restore` and `abandon` are destructive-looking rewrites even though the operation log can recover them. Use them only after reviewing the selected revision and paths.

                ### Rebase

                Use current `--onto/-o` terminology; `--destination/-d` is only a deprecated alias.

                ```bash
                # Rebase the branch containing @ onto trunk
                jj rebase -b @ -o 'trunk()'

                # Rebase a revision and all descendants
                jj rebase -s <change-id> -o <destination>

                # Rebase only selected revisions
                jj rebase -r <revset> -o <destination>
                ```

                Always inspect the graph and conflicts afterward.

                ## Native workspaces

                A workspace is jj's first-class equivalent of a Git worktree: a separate working directory and working-copy commit sharing commits, bookmarks, and the operation log with the same repository. Use `jj workspace`, never `git worktree`, in a jj repository.

                ### Create and inspect

                ```bash
                # New sibling working-copy commit on the current @'s parent(s)
                jj workspace add --name agent-task ../agent-task

                # New empty working-copy commit on an explicit revision
                jj workspace add --name agent-task -r <change-id> -m "Implement task" ../agent-task

                # Minimal or full sparse checkout (copy is the default)
                jj workspace add --name tests -r @ --sparse-patterns empty ../tests
                jj workspace add --name review -r 'trunk()' --sparse-patterns full ../review

                jj --no-pager workspace list
                jj workspace root
                jj workspace root --name agent-task
                ```

                `workspace add` creates a distinct empty working-copy commit. Without `-r`, its parents are the current working-copy commit's parents; use `-r @` if the new workspace must start on top of the current change.

                ### Workspace safety

                - Workspaces share repository state but never live-mirror files. Each command snapshots the current workspace and incorporates shared operation-log changes.
                - `jj log` labels workspace commits as `<workspace-name>@`.
                - Before `jj edit <change-id>`, use `jj workspace list` and the log to ensure another workspace is not using that revision as its working copy. Rewriting another workspace's `@` makes it stale and can require recovery.
                - If jj reports a stale working copy, stop and run:

                  ```bash
                  jj workspace update-stale
                  jj --no-pager status
                  jj --no-pager log -n 12
                  ```

                  If an interrupted or lost operation left unmatched filesystem contents, `update-stale` can preserve them in a recovery commit. Inspect before rewriting anything further.

                - Do not delete only the directory and leave repository metadata behind. Forget the workspace and delete files separately:

                  ```bash
                  jj workspace forget agent-task
                  rm -rf ../agent-task
                  ```

                - `jj workspace forget` does not delete files. `jj workspace rename <new-name>` renames only the current workspace.

                Workspaces are the preferred isolation mechanism for parallel agents, long-running tests, reviews, or unrelated tasks.

                ### Per-revision isolated commands (`jj run`, 0.43+)

                `jj run` creates private temporary working copies for selected revisions. By default, successful filesystem changes amend those revisions and rebase descendants. For read-only checks, always add `--ignore-changes`:

                ```bash
                # Test each local revision without rewriting it
                jj --no-pager run -r 'trunk()..@' --ignore-changes -- cargo test

                # Intentionally apply a formatter to selected mutable revisions
                jj --no-pager run -r 'trunk()..@' -- ruff format .
                ```

                Use explicit `-r` selection and review the graph afterward. Do not use `--ignore-errors` unless a zero exit code despite failed commands is intentional. Persistent agent isolation still belongs in named workspaces.

                ## Bookmarks and Git remotes

                ### Bookmarks

                ```bash
                jj --no-pager bookmark list
                jj bookmark create feature -r @
                jj bookmark set feature -r @
                jj bookmark set feature -r <ancestor> --allow-backwards
                jj bookmark advance feature --to @
                jj bookmark delete feature
                ```

                `bookmark set` creates or updates a bookmark by name. `bookmark advance` only moves eligible bookmarks forward and defaults its target to `@`.

                ### Clone, initialize, and fetch

                Git-backed clones and repositories are colocated by default in current jj:

                ```bash
                jj git clone <url> [destination]
                jj git clone --no-colocate <url> [destination]
                jj git init --colocate                    # inside an existing Git repository
                jj git fetch
                jj git fetch --remote origin
                jj git fetch --remote origin --bookmark main
                ```

                After fetching, inspect the log before rebasing:

                ```bash
                jj --no-pager log -n 20
                jj rebase -b @ -o 'trunk()'
                ```

                ### Push safely (jj 0.44)

                `--allow-new` was removed in jj 0.42. Selecting an untracked bookmark with `--bookmark` now tracks it automatically for the chosen remote.

                ```bash
                # Point a bookmark at the intended commit
                jj bookmark set feature -r @

                # Preview, then push that bookmark
                jj git push --remote origin --bookmark feature --dry-run
                jj git push --remote origin --bookmark feature

                # Or create an automatically named push bookmark (push-<change-id>)
                jj git push --remote origin --change @ --dry-run
                jj git push --remote origin --change @

                # Or choose a new remote bookmark name directly
                jj git push --remote origin --named feature=@ --dry-run
                jj git push --remote origin --named feature=@
                ```

                By default, `jj git push` pushes tracked bookmarks and tags in the relevant range. It uses force-with-lease-style safety checks. Never add `--allow-conflicts`, `--allow-private`, or `--allow-empty-description` merely to bypass a failure; inspect and fix the cause. Only push after explicit user authorization.

                ## Colocated Git safety

                Current jj allows Git and jj commands to be mixed in a **colocated** workspace (`.jj` and `.git`), and automatically imports/exports Git refs on each jj command. Agents should still use jj for mutations because:

                - jj usually leaves Git HEAD detached;
                - jj ignores Git's index/staging area;
                - jj does not understand unfinished Git merge/rebase state;
                - interleaving mutating commands can produce bookmark conflicts or divergent changes;
                - Git tools cannot faithfully represent jj's first-class conflicted commits.

                Read-only Git tools may be used only when a required integration has no jj equivalent. Do not run `git add`, `git commit`, `git checkout`/`switch`, `git rebase`, `git merge`, `git reset`, `git stash`, `git worktree`, `git fetch`, or `git push` in a jj repository unless the user explicitly requests an interoperability workflow and the colocated-state consequences are understood.

                Use these to inspect or convert colocation:

                ```bash
                jj git colocation status
                jj git colocation enable
                jj git colocation disable
                ```

                In a non-colocated repository, the backing Git repo is internal to `.jj`; do not operate on it directly.

                ## Conflicts

                A successful rebase or merge can still create conflicted commits. Check both status and the stack:

                ```bash
                jj --no-pager status
                jj --no-pager log -r 'conflicts()'
                ```

                Resolve without an interactive merge tool:

                1. Prefer `jj new <conflicted-change-id> -m "Resolve conflict in ..."` so the resolution is easy to inspect; alternatively `jj edit <conflicted-change-id>` after checking workspaces.
                2. Edit each file and remove/resolve all jj conflict sections from `<<<<<<<` through `>>>>>>>`.
                3. Run `jj --no-pager diff --git` and `jj --no-pager status`.
                4. If using a child resolution commit, move it into the conflicted parent with `jj squash -m "<final parent description>"` or `--use-destination-message`.
                5. Verify `jj --no-pager log -r 'conflicts()'` is empty for the affected stack.

                Do not assume Git's simple two-sided markers: jj can materialize snapshot/diff-style and many-sided conflicts.

                ## Recovery and operation log

                ```bash
                jj --no-pager op log
                jj undo                 # sequentially revert the latest operation
                jj redo                 # reapply the most recently undone operation
                jj op revert <op-id>    # invert one selected operation
                jj op restore <op-id>   # restore the entire repo state to that operation
                jj --at-op=<op-id> --no-pager log
                ```

                Inspect `jj op log` before repeated `undo`: modern `jj undo` is sequential, so invoking it repeatedly walks backward through operations. `jj op undo` was removed in 0.39; use `jj undo`, `jj redo`, `jj op revert`, or `jj op restore`.

                ## Completion checklist

                1. `jj --no-pager status`
                2. `jj --no-pager diff --git`
                3. `jj --no-pager show @`
                4. Confirm one logical change and no unrelated/user-owned files.
                5. Confirm a clear imperative description.
                6. `jj --no-pager log -r 'trunk()..@'` to inspect stack shape, bookmarks, divergence, and conflicts.
                7. If a workspace was added, either keep it intentionally or `jj workspace forget` it before deleting its directory.
                8. Do not push unless explicitly requested.
              '';
          })
        ];
      };

    base =
      homeArgs@{ pkgs, ... }:
      {
        programs.jujutsu = {
          enable = true;
          package = pkgs.jujutsu;
          settings = {
            user = {
              inherit (config.flake.meta.owner) email;
              name = config.flake.meta.accounts.github.username;
            };
            colors = {
              change_id = "#04a5e5";
              commit_id = {
                fg = "#40a02b";
                bold = true;
              };
            };
            signing = {
              behavior = "own";
              backend = "ssh";
              key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESOx5jXSV+jeGmIpVO3ASIByLflNIhnkfAlmXOnMsXk";
            };
            templates = {
              commit_trailers = ''
                format_signed_off_by_trailer(self)
                ++ if(!trailers.contains_key("Change-Id"), format_gerrit_change_id_trailer(self))'';
            };
            git.sign-on-push = true;
            ui.show-cryptographic-signatures = true;
            ui.editor = lib.mkIf homeArgs.config.programs.helix.enable "hx";
            git = {
              private-commits = "description(glob:'private:*')";
            };
            fix = {
              tools = {
                rustfmt = {
                  enabled = true;
                  command = [
                    "${pkgs.rustfmt}/bin/rustfmt"
                    "--emit"
                    "stdout"
                  ];
                  patterns = [ "glob:'**/*.rs'" ];
                };
                nixfmt = {
                  enabled = true;
                  command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
                  patterns = [ "glob:'**/*.nix'" ];
                };
              };
            };
          };
        };
      };
  };
}
