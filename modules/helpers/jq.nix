{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.jq = {
        enable = true;
        package = pkgs.jq;
      };
    };
}
