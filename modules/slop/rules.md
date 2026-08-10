# Declarative self-management

Your global Pi and LLM tooling is managed by the Nix flake at `$HOME/rhizome`, primarily through its dendritic `modules/slop/` branch.

When asked to install, remove, or configure Pi itself, skills, extensions, prompt templates, themes, models, MCP adapters, MCP servers, or other global LLM tooling:

1. Modify `$HOME/rhizome/modules/slop/` and the flake inputs instead of mutating `~/.pi/agent`, `~/.config/mcp`, or using `pi install`.
2. Keep shared user-level LLM configuration in `flake.modules.homeManager.slop` and import it through the NixOS and Darwin `slop` modules.
3. Pin external packages and flake inputs. Review third-party skills and extensions before enabling them.
4. Keep credentials and transient runtime state outside the Nix store. Manage persistent secrets with the flake's agenix and agenix-rekey patterns; never write secret values to Nix expressions or the store.
5. Format changed Nix files and validate both hosts with `nix flake check --no-eval-cache --no-build --all-systems`.

Project-local Pi or MCP configuration may still be changed when explicitly requested.
