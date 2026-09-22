{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      jj = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "jj.yazi";
        version = "26.8.15-unstable-2026-09-22";

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
          rev = "7c2e3751d0e8d3de65a17df3f943afa906d6905d";
          hash = "sha256-WnGwMgha6DHrO5fPESd4IU9y2+fBWgH5bVE4E+PaG6s=";
        };

        meta = {
          description = "Show the status of Jujutsu file changes as linemode in the file list";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ LilDojd ];
        };
      };
    in
    {
      programs.yazi = {
        plugins = {
          inherit jj;
        };
        initLua = ''
          require("jj"):setup()
        '';
        settings.plugin.prepend_fetchers = lib.mkBefore [
          {
            url = "*";
            run = "jj";
            group = "jj";
          }
          {
            url = "*/";
            run = "jj";
            group = "jj";
          }
        ];
      };
    };
}
