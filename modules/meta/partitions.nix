{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.partitions ];

  # Keep one lockfile; only development outputs load the tooling modules.
  partitionedAttrs = {
    apps = "dev";
    checks = "dev";
    devShells = "dev";
    formatter = "dev";
  };
}
