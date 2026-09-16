{ lib, ... }:
{
  options.text = lib.mkOption {
    default = { };
    type = lib.types.lazyAttrsOf (
      lib.types.oneOf [
        (lib.types.separatedString "")
        (lib.types.submodule {
          options = {
            parts = lib.mkOption {
              type = lib.types.lazyAttrsOf lib.types.str;
            };
            order = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
          };
        })
      ]
    );
    apply = lib.mapAttrs (
      name: text:
      if lib.isAttrs text then
        lib.pipe text.order [
          (map (lib.flip lib.getAttr text.parts))
          lib.concatStrings
        ]
      else
        text
    );
  };

  config = {
    flake-file.inputs.files = {
      url = "github:mightyiam/files";
      flake = false;
    };

    partitions.dev.module =
      {
        inputs,
        config,
        withSystem,
        ...
      }:
      {
        imports = [ (inputs.files + "/flake-module.nix") ];

        text.readme.parts.files =
          withSystem (builtins.head config.systems) (psArgs: lib.attrNames psArgs.config.files.file)
          |> map (path: "- `${path}`")
          |> lib.naturalSort
          |> lib.concat [
            # markdown
            ''
              ## Generated files

              The following files in this repository are generated and checked
              using [the _files_ flake-parts module](https://github.com/mightyiam/files):
            ''
          ]
          |> lib.concatLines
          |> (s: s + "\n");

        perSystem = psArgs: {
          files.writer.app = true;
          devshells.default.packages = [ psArgs.config.files.writer.drv ];
        };
      };
  };
}
