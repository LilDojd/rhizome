{ inputs, ... }:
{
  flake.modules.homeManager.base = { config, ... }: {
    imports = [ inputs.nhx.homeManagerModules.default ];

    programs.nhx = {
      enable = true;
      steel.enable = true;
      plugins = {
        scooter.enable = true;
        show-keys = {
          enable = true;
          requirePath = "showkeys/showkeys.scm";
        };
        oil = {
          enable = true;
          config.showDotfiles = true;
        };
      };
      settings = {
        theme = config.programs.helix.settings.theme;
        editor = {
          auto-format = true;
          bufferline = "multiple";
          color-modes = true;
          cursorline = true;
          default-yank-register = "+";
          rainbow-brackets = true;
          line-number = "relative";
          mouse = true;
          rulers = [ 80 ];
          scrolloff = 10;

          indent-guides = {
            render = true;
            character = "|";
          };

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          file-picker.hidden = false;
          auto-save = {
            focus-lost = true;
            after-delay = {
              enable = true;
              timeout = 1000;
            };
          };

          lsp = {
            enable = true;
            display-messages = true;
            display-inlay-hints = true;
          };

          statusline = {
            left = [
              "mode"
              "spinner"
              "file-name"
              "file-modification-indicator"
            ];
            right = [
              "diagnostics"
              "separator"
              "workspace-diagnostics"
              "selections"
              "position"
            ];
            separator = "│";
            mode = {
              normal = "NOR";
              insert = "INS";
              select = "SEL";
            };
          };
        };

        keys = {
          insert.j.k = "normal_mode";

          normal = {
            "C-p" = "@:sh ";
            "ret" = "goto_word";
            "C-j" = "page_down";
            "C-k" = [
              "page_up"
              "goto_window_top"
            ];
            backspace = {
              y = ":yank-diagnostic";
              backspace = "suspend";
            };

            "space" = {
              b = {
                f = "buffer_picker";
                q = ":buffer-close";
                p = ":buffer-previous";
                n = ":buffer-next";
              };
              o = {
                o = ":oil";
                e = ":oil-enter";
                b = ":oil-back";
                g = ":oil-root";
                s = ":oil-save";
                r = ":oil-refresh";
                q = ":oil-close";
                h = ":oil-toggle-hidden";
                i = ":oil-toggle-git-ignored";
                m = {
                  y = ":oil-yank";
                  x = ":oil-cut";
                  p = ":oil-paste";
                  c = ":oil-clipboard-clear";
                };
              };
            };
          };
        };
      };
      languages = {
        language-server = {
          nixd.command = "nixd";
          ty = {
            command = "ty";
            args = [ "server" ];
          };
        };

        language = [
          {
            name = "nix";
            language-servers = [
              "nixd"
              "nil"
            ];
            formatter.command = "nixfmt";
          }
          {
            name = "python";
            language-servers = [
              "ty"
              "ruff"
            ];
            auto-format = true;
          }
          {
            name = "markdown";
            language-servers = [
              "marksman"
              "markdown-oxide"
            ];
          }
        ];
      };
    };

    home.file.".config/helix/themes/stylix.toml".source = config.programs.helix.themes.stylix;
  };
  flake.modules.homeManager.hyprland.wayland.windowManager.hyprland.settings.env = [
    {
      _args = [
        "EDITOR"
        "hx"
      ];
    }
  ];
  flake.modules.nixos.foundation.environment.variables.EDITOR = "hx";
  flake.modules.darwin.foundation.environment.variables.EDITOR = "hx";
}
