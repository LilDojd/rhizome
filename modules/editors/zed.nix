{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;

        extensions = [
          "catppuccin"
          "nix"
          "python"
          "toml"
          "rust"
        ];

        userKeymaps = [
        ];

        userSettings = {
          base_keymap = "VSCode";
          load_direnv = "shell_hook";
          helix_mode = true;

          lsp = {
            nixd = {
              binary = {
                path = lib.getExe pkgs.nixd;
              };
            };
            rust-analyzer = {
              binary = {
                path = lib.getExe pkgs.rust-analyzer;
              };
            };
            ty = {
              binary = {
                path = lib.getExe pkgs.ty;
                arguments = [ "server" ];
              };
            };
          };

          languages = {
            Nix = {
              language_servers = [
                "nixd"
                "!nil"
              ];
              formatter = {
                external = {
                  command = lib.getExe pkgs.nixfmt;
                };
              };
            };
            Python = {
              language_servers = [
                "ty"
                "ruff"
              ];
            };
          };
        };
      };
    };
}
