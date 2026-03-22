{ lib, config, ... }:
{
  options.nix.settings = lib.mkOption { type = lib.types.lazyAttrsOf lib.types.anything; };
  config = {
    nix.settings = {
      keep-outputs = true;
      download-buffer-size = 524288000;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
        "recursive-nix"
      ];
      extra-system-features = [ "recursive-nix" ];
      # export NIX_CONFIG="substituters = https://cache.nixos.org https://hyprland.cachix.org\ntrusted-public-keys = hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      extra-substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://helix.cachix.org"
        "https://install.determinate.systems"
      ];
      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      ];

    };
    flake.modules = {
      nixos.foundation.nix = {
        inherit (config.nix) settings;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        optimise.automatic = true;
      };
      nixos.agenix.nix = { inherit (config.nix) settings; };
      homeManager.base.nix = { inherit (config.nix) settings; };
    };
  };
}
