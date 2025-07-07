{ lib, config, ... }:
{
  options.nix.settings = lib.mkOption { type = lib.types.lazyAttrsOf lib.types.anything; };
  config = {
    nix.settings = {
      keep-outputs = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
        "recursive-nix"
      ];
      extra-system-features = [ "recursive-nix" ];
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://helix.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

    };
    flake.modules = {
      nixos.foundation.nix = { inherit (config.nix) settings; };

      darwin.foundation.nix = { inherit (config.nix) settings; };

      homeManager.base.nix = { inherit (config.nix) settings; };

    };
  };
}
