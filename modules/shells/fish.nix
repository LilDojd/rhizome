{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    let
      catppuccin-fish = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "fish";
        rev = "6a85af2ff722ad0f9fbc8424ea0a5c454661dfed";
        hash = "sha256-Oc0emnIUI4LV7QJLs4B2/FQtCFewRFVp7EDv8GawFsA=";
      };
      shellAliasAbbrs = lib.mapAttrs (
        _: val: builtins.baseNameOf (lib.head (lib.splitString " " val))
      ) config.home.shellAliases;
    in
    {
      home.packages = with pkgs; [ grc ];
      xdg.configFile."fish/themes/Catppuccin Macchiato.theme".source =
        "${catppuccin-fish}/themes/Catppuccin Macchiato.theme";
      programs.fish = {
        enable = true;

        shellAliases = lib.mkForce { };

        shellInit = ''
          set fish_greeting ""
          ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
          set fzf_fd_opts --hidden --max-depth 5

          function __ls_after_cd__on_variable_pwd --on-variable PWD
            if test "$LS_AFTER_CD" = true; and status --is-interactive
                ls -GF
            end
          end

          function __sync_history --on-event fish_preexec
              history save
              history merge
          end

          if status --is-interactive && test -z "$TMUX"
              fish_config theme choose "Catppuccin Macchiato"
          end
        '';
        preferAbbrs = true;
        shellAbbrs = shellAliasAbbrs // {

          ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
          cat = "bat";

          grep = "grep --color=auto";
          mtar = "tar -zcvf";
          utar = "tar -zxvf";
          uz = "unzip";

          vim = "nvim";

          mv = "mv -v";
          cp = "cp -vr";
          rm = "rm -vr";

          ".." = "cd ..";
          "..." = "cd ../..";
          ".3" = "cd ../../..";
          ".4" = "cd ../../../..";
          ".5" = "cd ../../../../..";
        };

        plugins = [
          # Enable a plugin (here grc for colorized command output) from nixpkgs
          {
            name = "grc";
            inherit (pkgs.fishPlugins.grc) src;
          }
          # Manually packaging and enable a plugin
          {
            name = "z";
            src = pkgs.fetchFromGitHub {
              owner = "jethrokuan";
              repo = "z";
              rev = "067e867debee59aee231e789fc4631f80fa5788e";
              hash = "sha256-emmjTsqt8bdI5qpx1bAzhVACkg0MNB/uffaRjjeuFxU=";
            };
          }
          {
            name = "fzf";
            inherit (pkgs.fishPlugins.fzf-fish) src;
          }
          {
            name = "autopair";
            inherit (pkgs.fishPlugins.autopair) src;
          }
        ];
      };
    };
}
