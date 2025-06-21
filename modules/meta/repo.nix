{ config, ... }:
{
  flake.meta.repo = {
    forge = "github";
    owner = config.flake.meta.accounts.github.username;
    name = "rhizome";
    defaultBranch = "main";
  };
}
