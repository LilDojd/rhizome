{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # Follow the live checkout, not the immutable source used for this rebuild.
      flake = "(builtins.getFlake ${builtins.toJSON config.programs.nh.flake})";
      host =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "${flake}.darwinConfigurations.darwinforest"
        else
          "${flake}.nixosConfigurations.darkforest";
      settings = {
        nixpkgs.expr = "${host}.pkgs";
        formatting.command = [ (lib.getExe pkgs.nixfmt) ];
        options = {
          nixos.expr = "${flake}.nixosConfigurations.darkforest.options";
          darwin.expr = "${flake}.darwinConfigurations.darwinforest.options";
          home-manager.expr = "${host}.options.home-manager.users.type.getSubOptions []";
          flake-parts.expr = "${flake}.debug.partitions.dev.module.flake.debug.options";
          per-system.expr = "${flake}.debug.partitions.dev.module.flake.allSystems.${pkgs.stdenv.hostPlatform.system}.options";
        };
      };
    in
    {
      programs.nhx.languages.language-server.nixd = {
        command = lib.getExe pkgs.nixd;
        config.nixd = settings;
      };
      programs.zed-editor.userSettings.lsp.nixd = {
        binary.path = lib.getExe pkgs.nixd;
        inherit settings;
      };
    };
}
