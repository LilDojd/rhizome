{ lib, ... }:
{
  options.gitignore = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };

  config.partitions.dev.module = { config, ... }: {
    perSystem = {
      files.file.".gitignore".text = config.gitignore |> lib.naturalSort |> lib.concatLines;

      treefmt.settings.global.excludes = [ "*/.gitignore" ];
    };
  };
}
