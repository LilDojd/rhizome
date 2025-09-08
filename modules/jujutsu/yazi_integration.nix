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
          rev = "2dd1dbc21306739c1871dbe13c04ca0e39d2c168";
          hash = "sha256-73+iDVByaTWOsDI5A3/0TI9p56bWW6Kt3rlPRIpLEgQ=";
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
