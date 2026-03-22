{ config, ... }:
{
  text.readme = {
    order = [
      "intro"
      "ci-badge"
      "flakehub"
      "attribution"
      "determinate"
      "nixos-configurations"
      "github-actions"
      "files"
    ];

    parts.intro =
      # markdown
      ''
        # ${config.flake.meta.repo.owner}/${config.flake.meta.repo.name}

        ${config.flake.meta.owner.name}'s [Nix](https://nix.dev)-powered system configuration repository.
        Manages NixOS and nix-darwin hosts, home-manager modules, and development environments declaratively.

        > [!NOTE]
        > If you have any questions or suggestions, feel free to use the discussions feature or contact me.

      '';

    parts.determinate =
      # markdown
      ''
        ## Determinate

        Flake inputs are sourced from [FlakeHub](https://flakehub.com) where available.
        macOS is managed by [Determinate Nix](https://determinate.systems),
        which provides a curated Nix installation for darwin systems.

      '';

    parts.attribution =
      # markdown
      ''
        ## Acknowledgements

        > [!IMPORTANT]
        > This repository is heavily inspired by [@mightyiam](https://github.com/mightyiam)'s
        > infrastructure repo. The architecture, patterns, and much of the tooling
        > originate from his work. All praise should go to him.

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
