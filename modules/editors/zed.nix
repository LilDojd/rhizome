{ lib, config, ... }:
{
  flake.modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
    [
      ".local/share/zed"
    ];
  flake.modules.homeManager.base =
    { ... }:
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
          {
            context = "Editor && vim_mode == insert";
            bindings = {
              "j k" = "vim::NormalBefore";
            };
          }
        ];

        userSettings = {
          base_keymap = "VSCode";
          load_direnv = "shell_hook";
          helix_mode = true;
          inlay_hints = {
            enabled = true;
          };

          ui_font_size = lib.mkForce 14;
          buffer_font_size = lib.mkForce 14;

          lsp = {
            nixd = {
              binary = {
                path = "nixd";
              };
            };
            rust-analyzer = {
              binary = {
                path = "rust-analyzer";
              };
            };
            ty = {
              binary = {
                path = "ty";
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
                  command = "nixfmt";
                };
              };
            };
            Python = {
              language_servers = [
                "ty"
              ];
            };
          };
        };
      };
    };
}
