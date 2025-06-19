{ config, ... }:
{
  flake.modules.homeManager.base.programs.git = {
    userName = config.flake.meta.owner.githubUsername;
    userEmail = config.flake.meta.owner.email;
    extraConfig = {
      # FOSS-friendly settings
      push.default = "simple"; # Match modern push behavior
      credential.helper = "cache --timeout=7200";
      init.defaultBranch = "main"; # Set default new branches to 'main'

      ignores = [
        ".DS_Store"
        "*.swp"
        ".direnv"
        ".envrc"
        ".envrc.local"
        ".env"
        ".env.local"
        ".jj"
        "/.tool-versions"
        "*.key"
        "debug/"
        "target/"

        "**/*.rs.bk"

      ];
    };
  };
}
