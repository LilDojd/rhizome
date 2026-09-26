{ config, ... }:
{
  flake = {
    meta.accounts.github.username = "LilDojd";

    modules.nixos.foundation.environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories =
      [
        ".config/github-copilot"
      ];
    modules.nixos.agenix =
      { config, ... }:
      {
        age.secrets = {
          githubToken = {
            rekeyFile = ./githubToken.age;
            intermediary = true;
          };
          nixAccessTokens = {
            rekeyFile = ./nixAccessTokens.age;
            group = "wheel";
            mode = "0440";
            generator = {
              dependencies = [ config.age.secrets.githubToken ];
              script =
                {
                  lib,
                  decrypt,
                  deps,
                  ...
                }:
                ''
                  printf 'access-tokens = github.com=%s\n' "$(${decrypt} ${lib.escapeShellArg (lib.head deps).file})"
                '';
            };
          };
        };
        nix.extraOptions = "!include ${config.age.secrets.nixAccessTokens.path}";
      };
    modules.homeManager = {
      base =
        { pkgs, ... }:
        {
          programs.gh = {
            package = pkgs.gh.overrideAttrs (oldAttrs: {
              buildInputs = oldAttrs.buildInputs or [ ] ++ [ pkgs.makeWrapper ];
              postInstall = oldAttrs.postInstall or "" + ''
                wrapProgram $out/bin/gh --unset GITHUB_TOKEN
              '';
            });
            enable = true;
            extensions = [ pkgs.ghstack ];
            settings.git_protocol = "ssh";
          };

          home.packages = with pkgs; [ gh-dash ];
        };
      gui =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [ gh-markdown-preview ];
        };
    };
  };
}
