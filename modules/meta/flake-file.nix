{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.default ];

  flake-file = {
    description = "Yawner's Nix Environment";
    outputs = "dendritic";
    nixConfig = {
      abort-on-warn = true;
      extra-experimental-features = [
        "flakes"
        "pipe-operators"
      ];
      allow-import-from-derivation = false;
      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
    inputs = {
      self.submodules = true;
      flake-file.url = "github:denful/flake-file";
      import-tree.url = "github:vic/import-tree";

      # Inputs used only as shared targets for explicit follows declarations.
      dedupe_flake-compat.url = "github:NixOS/flake-compat";
      dedupe_nur = {
        url = "github:nix-community/NUR";
        inputs = {
          flake-parts.follows = "flake-parts";
          nixpkgs.follows = "nixpkgs";
        };
      };
    };
  };
}
