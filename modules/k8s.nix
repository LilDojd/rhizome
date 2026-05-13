{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.kubectl
      ];
      programs.kubecolor = {
        enable = true;
        enableAlias = true;
        enableZshIntegration = true;
      };
      home.shellAliases.k = "kubecolor";
    };
}
