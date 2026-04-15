{

  description = "Yawner's Nix Environment";

  nixConfig = {
    abort-on-warn = false;
    extra-experimental-features = [
      "flakes"
      "pipe-operators"
    ];
    allow-import-from-derivation = false;
  };

  inputs.self.submodules = true;
  inputs = {

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";

    agenix = {
      url = "https://flakehub.com/f/ryantm/agenix/0.15.*";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    agenix-rekey = {
      url = "https://flakehub.com/f/oddlama/agenix-rekey/0.1.*";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-mineral = {
      url = "github:cynicsketch/nix-mineral";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cpu-microcodes = {
      flake = false;
      url = "github:platomav/CPUMicrocodes";
    };
    nix-alien = {
      url = "https://flakehub.com/f/thiagokokada/nix-alien/0.1.*";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-index-database.follows = "nix-index-database";
        flake-compat.follows = "dedupe_flake-compat";
      };
    };
    # TODO: remove ashell input once https://github.com/NixOS/nixpkgs/pull/504175 is merged
    ashell = {
      url = "github:MalpenZibo/ashell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/0.54.*";
    input-branches.url = "github:mightyiam/input-branches";
    clipboard-sync = {
      url = "github:dnut/clipboard-sync";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "https://flakehub.com/f/nix-community/disko/1.13.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "https://flakehub.com/f/nix-community/impermanence/0.1.*";

    helix = {
      url = "https://flakehub.com/f/helix-editor/helix/0.1.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    files = {
      url = "github:mightyiam/files";
    };

    systems = {
      url = "github:nix-systems/default";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-mole = {
      url = "github:tw93/homebrew-tap";
      flake = false;
    };

    flake-parts = {
      url = "https://flakehub.com/f/hercules-ci/flake-parts/0.1.*";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    git-hooks = {
      url = "https://flakehub.com/f/cachix/git-hooks.nix/0.1.*";
      inputs = {
        flake-compat.follows = "dedupe_flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "dedupe_systems";
        flake-compat.follows = "dedupe_flake-compat";
      };
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    sink-rotate = {
      url = "github:mightyiam/sink-rotate";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    stylix = {
      url = "https://flakehub.com/f/nix-community/stylix/0.1.*";
      flake = true;
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        nur.follows = "dedupe_nur";
        systems.follows = "dedupe_systems";
        tinted-schemes.follows = "tinted-schemes";
      };
    };

    tinted-schemes = {
      flake = false;
      url = "github:tinted-theming/schemes";
    };

    treefmt-nix = {
      url = "https://flakehub.com/f/numtide/treefmt-nix/0.1.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ucodenix = {
      url = "github:e-tho/ucodenix";
      inputs.cpu-microcodes.follows = "cpu-microcodes";
    };

    jj-starship = {

      url = "github:dmmulroy/jj-starship";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mt7927 = {
      url = "github:cmspam/mt7927-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # _additional_ `inputs` only for deduplication
    dedupe_flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.1.*";

    dedupe_flake-utils = {
      url = "https://flakehub.com/f/numtide/flake-utils/0.1.*";
      inputs.systems.follows = "dedupe_systems";
    };

    dedupe_nur = {
      url = "github:nix-community/NUR";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    dedupe_systems.url = "github:nix-systems/default";

    dedupe_nuschtos-search = {
      url = "github:NuschtOS/search";
      inputs = {
        flake-utils.follows = "dedupe_flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      text.readme.parts = {
        disallow-warnings =
          # markdown
          ''
            ## Trying to disallow warnings

            This at the top level of the `flake.nix` file:

            ```nix
            nixConfig.abort-on-warn = true;
            ```

            > [!NOTE]
            > It does not currently catch all warnings Nix can produce, but perhaps only evaluation warnings.
          '';

        flake-inputs-dedupe-prefix =
          # markdown
          ''
            ## Flake inputs for deduplication are prefixed

            Some explicit flake inputs exist solely for the purpose of deduplication.
            They are the target of at least one `<input>.inputs.<input>.follows`.
            But what if in the future all of those targeting `follows` are removed?
            Ideally, Nix would detect that and warn.
            Until that feature is available those inputs are prefixed with `dedupe_`
            and placed in an additional separate `inputs` attribute literal
            for easy identification.

          '';

        automatic-import =
          # markdown
          ''
            ## Automatic import

            Nix files (they're all flake-parts modules) are automatically imported.
            Nix files prefixed with an underscore are ignored.
            No literal path imports are used.
            This means files can be moved around and nested in directories freely.

            > [!NOTE]
            > This pattern has been the inspiration of [an auto-imports library, import-tree](https://github.com/vic/import-tree).

          '';

      };

      imports = [
        (inputs.import-tree ./modules)
      ];

      _module.args.rootPath = ./.;
    };
}
