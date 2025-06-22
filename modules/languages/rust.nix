{
  flake.modules = {
    homeManager.base =
      { pkgs, ... }:
      {
        programs.nvf.settings.vim.languages.rust = {
          enable = true;
          crates.enable = true;
        };
        programs.helix = {
          languages.language = [

            {
              name = "rust";
              language-servers = [ "rust-analyzer" ];
              auto-pairs = {
                "(" = ")";
                "{" = "}";
                "[" = "]";
                "\"" = ''"'';
                "`" = "`";
                "<" = ">";
              };
            }
          ];
          extraPackages = with pkgs; [
            rust-analyzer
          ];
        };
        home.packages = with pkgs; [
          cargo-watch
          cargo-outdated
          cargo-feature
          cargo-deny
          cargo-audit
        ];
      };
  };
}
