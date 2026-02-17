{ lib, ... }:
{
  # Temporary overlay until https://github.com/NixOS/nixpkgs/pull/490957 lands in nixpkgs-unstable.
  # Without this, the check phase invokes the proprietary Metal shader compiler on Darwin.
  nixpkgs.overlays = [
    (
      final: prev:
      lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
        zed-editor = prev.zed-editor.overrideAttrs (oldAttrs: {
          # checkFeatures is consumed by buildRustPackage before mkDerivation; the
          # resulting mkDerivation attribute is cargoCheckFeatures. Append
          # buildFeatures (gpui/runtime_shaders) so the check phase doesn't invoke
          # the proprietary Metal shader compiler.
          # TODO: remove once https://github.com/NixOS/nixpkgs/pull/490957 lands.
          cargoCheckFeatures = (oldAttrs.cargoCheckFeatures or [ ]) ++ (oldAttrs.cargoBuildFeatures or [ ]);
        });
      }
    )
  ];

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
              ];
            };
          };
        };
      };
    };
}
