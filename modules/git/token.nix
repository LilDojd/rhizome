{
  flake.modules.nixos.agenix =
    { config, pkgs, ... }:
    {
      age.secrets.githubToken = {
        rekeyFile = ./githubToken.age;
      };
      system.activationScripts."github-secret" = ''
          secret=$(cat ${config.age.secrets.githubToken.path})
          configFile=/etc/nix/nix.conf
          ${pkgs.gnused}/bin/sed -i "s#@github-secret-token@#$secret#" "$configFile"
        '';
      nix.settings = {
        access-tokens = [
          "github.com=@github-secret-token@"
        ];
      };
    };
}
