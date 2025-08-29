{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      jj = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "jj.yazi";
        version = "25.5.31-unstable-2025-07-05";

        installPhase = ''
          runHook preInstall
          cp -r jj.yazi $out
          rm $out/LICENSE
          cp LICENSE $out
          runHook postInstall
        '';

        src = pkgs.fetchFromGitHub {
          owner = "LilDojd";
          repo = "plugins";
          rev = "1d79d36941cc1e92bdce2300bff597c7a6fa42b4";
          hash = "sha256-Z8nBzjglGZRRkzyBb+CeaYKKRudE30bhrjWpWVC1mN4=";
        };

        meta = {
          description = "Show the status of Jujutsu file changes as linemode in the file list";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ LilDojd ];
        };
      };
    in
    {
      home.packages = with pkgs; [
        atool
        du-dust
        fd
        file
        ripgrep
        ripgrep-all
        unzip
        tokei
      ];
      programs = {
        yazi = {
          enable = true;
          enableFishIntegration = true;
          plugins = {
            inherit (pkgs.yaziPlugins) lazygit;
            inherit (pkgs.yaziPlugins) full-border;
            inherit (pkgs.yaziPlugins) smart-enter;
            inherit jj;
          };
          initLua = ''
            			require("full-border"):setup()
                  require("smart-enter"):setup {
                    open_multi = true,
                  }
                  require("jj"):setup()
            		'';
        };
        bat.enable = true;
      };
    };
}
