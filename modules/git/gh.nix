{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.gh = {
        enable = true;
        extensions = [ pkgs.ghstack ];
      };
    };
}
