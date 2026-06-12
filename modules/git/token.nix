{
  flake.modules.nixos.agenix =
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
}
