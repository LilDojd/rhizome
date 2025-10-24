{ config, ... }:
{
  flake.modules.homeManager.base.programs.git = {
    settings = {
      user.name = config.flake.meta.owner.githubUsername;
      user.email = config.flake.meta.owner.email;
      init.defaultBranch = "main";
      push.default = "current";
      commit.verbose = true;
      branch.sort = "-committerdate";
      tag.sort = "taggerdate";
    };
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
      ".basedpyright/"
      ".vscode"
    ];
  };
}
