{ lib, inputs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      helixPkg = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      programs.helix = {
        enable = true;
        package = helixPkg;
        settings = {
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
              "C-y" = [
                ":sh rm -f /tmp/unique-file"
                ":insert-output ${lib.getExe pkgs.yazi} %{buffer_name} --chooser-file=/tmp/unique-file"
                '':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty''
                ":open %sh{cat /tmp/unique-file}"
                ":redraw"
                ":set mouse false"
                ":set mouse true"
              ];

              backspace = {
                y = ":yank-diagnostic";
                backspace = "suspend";
              };

              "space".l.g = [
                ":new"
                ":insert-output ${lib.getExe pkgs.lazygit}"
                ":buffer-close!"
                ":redraw"
              ];

              "space".b = {
                f = "buffer_picker";
                q = ":buffer-close";
                p = ":buffer-previous";
                n = ":buffer-next";
              };
            };
          };
        };
        languages.language-server.nixd.command = lib.getExe pkgs.nixd;

        languages.language = [
          {
            name = "nix";
            language-servers = [
              "nixd"
              "nil"
            ];
            formatter.binary = lib.getExe pkgs.nixfmt-rfc-style;
            formatter.command = "nixfmt";
          }
          {
            name = "python";
            language-servers = [
              "basedpyright"
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

        extraPackages = with pkgs; [
          llvmPackages_18.clang-tools
          gopls
          nodePackages.bash-language-server
          dockerfile-language-server
          vscode-langservers-extracted
          texlab
          ruff
          basedpyright
          markdown-oxide
          marksman
          nodePackages.typescript-language-server
          nodePackages.prettier
          nixfmt-rfc-style
          nixd
          nil
          taplo
          python312Packages.python-lsp-server
          lua-language-server
        ];
      };
    };
}
