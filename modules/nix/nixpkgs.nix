{
  flake.modules.nixos.foundation = nixosArgs: {
    nix.settings.nix-path = [
      "nixpkgs=${nixosArgs.config.nixpkgs.flake.source}"
    ];
  };
}
