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
          languages = {
            language = [

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
            language-server.rust-analyzer.config.files.excludeDirs = [
              "_build"
              ".dart_tool"
              ".direnv"
              ".devenv"
              ".jj"
              ".flatpak-builder"
              ".git"
              ".gitlab"
              ".gitlab-ci"
              ".gradle"
              ".idea"
              ".next"
              ".project"
              ".scannerwork"
              ".settings"
              ".venv"
              "archetype-resources"
              "bin"
              "hooks"
              "node_modules"
              "po"
              "screenshots"
              "target"
            ];

            language-server.rust-analyzer.config.cargo = {
              features = "all";
              targetDir = true;
            };
          };
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
