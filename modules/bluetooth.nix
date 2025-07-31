{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ inputs.bluetui.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };
}
