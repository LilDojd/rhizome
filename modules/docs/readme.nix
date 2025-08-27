{ config, ... }:
{
  text.readme = {
    order = [
      "intro"
      "files"
    ];

    parts.intro =
      # markdown
      ''
        # ${config.flake.meta.repo.owner}/${config.flake.meta.repo.name}

        ${config.flake.meta.owner.name}'s [Nix](https://nix.dev)-powered "IT infrastructure" repository

        > [!NOTE]
        > I hope you find this helpful.
        > If you have any questions or suggestions for me, feel free to use the discussions feature or contact me.

      '';
  };

  perSystem =
    { pkgs, ... }:
    {
      files.files = [
        {
          path_ = "README.md";
          drv = pkgs.writeText "README.md" config.text.readme;
        }
      ];
    };
}
