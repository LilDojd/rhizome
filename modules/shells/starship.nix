_: {
  flake.modules.homeManager.base =

    {

      programs.starship = {
        enable = true;
        settings = {
          # General configuration
          format = "$directory $git_branch $conda $nix_shell $character";
          right_format = "$git_status$cmd_duration $rust";
          add_newline = false;

          # Languages disabled
          c = {
            disabled = true;
          };
          cmake = {
            disabled = true;
          };
          python = {
            disabled = true;
          };
          haskell = {
            disabled = true;
          };
          ruby = {
            disabled = true;
          };
          lua = {
            disabled = true;
          };
          perl = {
            disabled = true;
          };
          package = {
            disabled = true;
          };
          nodejs = {
            disabled = true;
          };
          java = {
            disabled = true;
          };
          golang = {
            disabled = true;
          };
          nix_shell = {
            format = "[$symbol$state( ($name))](bold blue) ";
            impure_msg = "[impure](bold red)";
            pure_msg = "[pure](bold green)";
            symbol = " ";
            disabled = false;
          };

          conda = {
            format = "[$symbol$environment](green) ";
            ignore_base = false;
          };

          # Character
          character = {
            success_symbol = "[](green bold)";
            error_symbol = "[](purple)";
          };

          # Rust
          rust = {
            format = "[[  ](fg:magenta)$version](fg:magenta)";
          };

          # Directory
          directory = {
            format = "[ ](fg:green)[$path](fg:green bold)";
            truncation_length = 3;
            truncate_to_repo = false;
          };

          # Git Branch
          git_branch = {
            format = "[[ ](bg:none fg:green bold)$branch](bg:base fg:magenta)";
            style = "bg:none fg:base";
          };

          # Git Status
          git_status = {
            format = "[$all_status$ahead_behind](fg:yellow)";
            conflicted = "=";
            ahead = "⇡$count";
            behind = "⇣$count";
            diverged = "⇕⇡$ahead_count⇣$behind_count";
            untracked = "?$count";
            stashed = "  ";
            modified = "!$count";
            staged = "+$count";
            renamed = "»$count";
            deleted = "$count";
          };

          # Command Duration
          cmd_duration = {
            min_time = 1;
            format = "[[λ](fg:flamingo bold)$duration](fg:text)";
            disabled = false;
          };
        };
      };
    };
}
