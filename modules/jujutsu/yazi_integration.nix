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
          rev = "ea851d1118f934fe260d8fb4917a89677af2445b";
          hash = "sha256-tApxNM0j9TnX1mAb1l7dfl9hruU68Nnud2BAEByJ0FU=";
        };

        meta = {
          description = "Show the status of Jujutsu file changes as linemode in the file list";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ LilDojd ];
        };
      };
    in
    {
      programs = {
        yazi = {
          enable = true;
          enableFishIntegration = true;
          plugins = {
            inherit jj;
          };
          initLua = ''
                  require("jj"):setup()
            		'';
        };
      };
    };
}
