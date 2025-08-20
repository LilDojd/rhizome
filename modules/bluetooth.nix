{ inputs, lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = lib.optionals (pkgs.stdenv.isLinux) [
        inputs.bluetui.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
