{ pkgs, lib, ... }:
let
  helix = (builtins.getFlake
    "github:helix-editor/helix/ab97585b69f11b159a447c85dfd528cc241cf1e3").packages.${pkgs.system}.default;
in {
  programs.helix = {
    enable = true;
    package = helix;
    settings = {
      editor = {
        auto-format = true;
        bufferline = "multiple";
        color-modes = true;
        cursorline = true;
        default-yank-register = "+";
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
          left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
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
          "C-k" = [ "page_up" "goto_window_top" ];
          "C-y" = [
            ":sh rm -f /tmp/unique-file"
            ":insert-output ${
              lib.getExe pkgs.yazi
            } --chooser-file=/tmp/unique-file"
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

    languages.language-server.nixd = { command = "${lib.getExe pkgs.nixd}"; };

    languages.language = [
      {
        name = "typescript";
        language-servers = [ "typescript-language-server" ];
        formatter = {
          command = "prettier";
          args = [ "--parser" "typescript" ];
          binary = "${lib.getExe pkgs.nodePackages.prettier}";
        };
      }
      {
        name = "nix";
        language-servers = [ "nixd" ];
        formatter.binary = "${lib.getExe pkgs.nixfmt-classic}";
        formatter.command = "nixfmt";
      }
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

      {
        name = "python";
        language-servers = [ "basedpyright" "ruff" ];
        auto-format = true;
      }

      {
        name = "markdown";
        language-servers = [ "marksman" "markdown-oxide" ];
      }
    ];

    # LSPs and formatters installed globally for convenience
    extraPackages = with pkgs; [
      llvmPackages_18.clang-tools # C/C++
      rust-analyzer # Rust
      gopls # Golang
      nodePackages.bash-language-server # Bash
      dockerfile-language-server-nodejs # Dockerfile
      vscode-langservers-extracted # HTML/CSS/JSON
      texlab # LaTEX

      ruff
      basedpyright

      # Markdown
      markdown-oxide
      marksman

      # TS/JS
      nodePackages.typescript-language-server
      nodePackages.prettier

      # Nix
      nixfmt-classic
      nixd

      cmake-language-server
      taplo
      python312Packages.python-lsp-server
      lua-language-server
    ];
  };
}
