{ self, ... }:
{
  partitions.dev.module.perSystem =
    {
      config,
      lib,
      pkgs,
      system,
      ...
    }:
    let
      host =
        if pkgs.stdenv.hostPlatform.isDarwin then
          self.darwinConfigurations.darwinforest
        else
          self.nixosConfigurations.darkforest;
      home = host.config.home-manager.users.${self.meta.owner.username};
      homeOptions =
        host.options.home-manager.users.valueMeta.attrs.${self.meta.owner.username}.configuration.options;
      helix = home.programs.nhx.languages;
      zed = home.programs.zed-editor.userSettings;
      nixLanguage = lib.findFirst (language: language.name == "nix") null helix.language;
      developmentOptions = [
        "devshells"
        "files"
        "input-branches"
        "pre-commit"
        "treefmt"
      ];
    in
    {
      checks.development-tooling =
        # Development schemas must not leak into the base per-system evaluation.
        assert builtins.all (
          name: !(builtins.hasAttr name self.allSystems.${system}.options)
        ) developmentOptions;
        assert builtins.all (name: builtins.hasAttr name config) developmentOptions;
        assert self.devShells.${system}.default.drvPath == config.devShells.default.drvPath;
        assert self.formatter.${system}.drvPath == config.formatter.drvPath;
        assert self.apps.${system}.write-files.program == config.apps.write-files.program;
        assert homeOptions.programs ? nhx && homeOptions.programs ? nvf;
        assert helix.language-server.nixd.config.nixd == zed.lsp.nixd.settings;
        assert helix.language-server.nixd.command == lib.getExe pkgs.nixd;
        assert zed.lsp.nixd.binary.path == lib.getExe pkgs.nixd;
        assert nixLanguage.formatter.command == lib.getExe pkgs.nixfmt;
        assert zed.languages.Nix.formatter.external.command == lib.getExe pkgs.nixfmt;
        assert home.programs.nix-your-shell.enable && home.programs.nix-your-shell.enableFishIntegration;
        assert !(lib.hasInfix "any-nix-shell" home.programs.fish.shellInit);
        assert builtins.all (name: builtins.elem name (map lib.getName home.home.packages)) [
          "nix-inspect"
          "nix-melt"
        ];
        pkgs.runCommand "development-tooling-check" { } ''
          touch "$out"
        '';
    };
}
