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
    };
    flake.modules = {
      nixos.pc.nix = { inherit (config.nix) settings; };

      darwin.pc.nix = { inherit (config.nix) settings; };

      homeManager.base.nix = { inherit (config.nix) settings; };

    };
  };
}
