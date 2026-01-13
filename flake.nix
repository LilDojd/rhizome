{

  description = "Yawner's Nix Environment";

  nixConfig = {
    abort-on-warn = true;
    extra-experimental-features = [
      "flakes"
      "pipe-operators"
    ];
    allow-import-from-derivation = false;
  };

  inputs.self.submodules = true;
  inputs = {

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
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
      url = "github:thiagokokada/nix-alien";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-index-database.follows = "nix-index-database";
        flake-compat.follows = "dedupe_flake-compat";
      };
    };
    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    # Custom hyprland scripts
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    presenterm = {
      url = "github:mfontanini/presenterm";
      inputs.flake-utils.follows = "dedupe_flake-utils";
    };
    bluetui = {
      url = "github:pythops/bluetui";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "dedupe_flake-utils";
      };
    };
    fzf-preview = {
      url = "github:niksingh710/fzf-preview";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "dedupe_systems";
      };
    };
    input-branches.url = "github:mightyiam/input-branches";
    clipboard-sync = {
      url = "github:dnut/clipboard-sync";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    helix = {
      url = "github:helix-editor/helix";
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

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
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

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
        systems.follows = "dedupe_systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    swww.url = "github:LGFae/swww";

    stylix = {
      url = "github:nix-community/stylix/pull/2130/head";
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
      url = "github:numtide/treefmt-nix";
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

  };

  # _additional_ `inputs` only for deduplication
  inputs = {
    dedupe_flake-compat.url = "github:edolstra/flake-compat";

    dedupe_flake-utils = {
      url = "github:numtide/flake-utils";
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
