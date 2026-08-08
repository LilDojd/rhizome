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
        age.secrets.githubToken = {
          rekeyFile = ./githubToken.age;
        };
        system.activationScripts.github-access-token = {
          deps = [
            "agenix"
            "etc"
          ];
          text = ''
            umask 0337
            rm -f /etc/nix/access-tokens.conf
            printf 'access-tokens = github.com=%s\n' "$(cat ${config.age.secrets.githubToken.path})" > /etc/nix/access-tokens.conf
            chown root:wheel /etc/nix/access-tokens.conf
          '';
        };
        nix.extraOptions = "!include /etc/nix/access-tokens.conf";
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
