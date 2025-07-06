{
  flake.modules.nixos.foundation = nixosArgs: {
    nix.nixPath = [
      "nixpkgs=${nixosArgs.config.nixpkgs.flake.source}"
    ];
  };
}
