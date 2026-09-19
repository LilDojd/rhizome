{ config, inputs, ... }:
let
  mkSlopModule = module: {
    imports = [ module ];
    dendriticSlop = {
      enable = true;
      username = config.flake.meta.owner.username;
    };
  };
in
{
  flake-file.inputs = {
    dendritic-slop = {
      url = "github:LilDojd/dendritic-slop";
      inputs = {
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        impermanence.follows = "impermanence";
        llm-agents.follows = "llm-agents";
        import-tree.follows = "import-tree";
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
  };

  flake.modules.nixos.slop = mkSlopModule inputs.dendritic-slop.modules.nixos.slop;
  flake.modules.darwin.slop = mkSlopModule inputs.dendritic-slop.modules.darwin.slop;
}
