{ config, inputs, ... }:
let
  owner = config.flake.meta.owner.username;
  home-manager.users.${owner}.imports = [
    inputs.dendritic-slop.modules.homeManager.default
    config.flake.modules.homeManager.slop
  ];
  persistentDirectories = [
    ".claude"
    ".pi/agent"
    ".tsk"
  ];
in
{
  flake-file.inputs = {
    dendritic-slop = {
      url = "github:LilDojd/dendritic-slop";
      inputs = {
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        llm-agents.follows = "llm-agents";
        import-tree.follows = "import-tree";
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

  flake.modules.nixos.slop =
    { config, ... }:
    {
      inherit home-manager;
      environment.persistence."/persistent".users.${owner}.directories = persistentDirectories;
      systemd.services."home-manager-${owner}".unitConfig.RequiresMountsFor = map (
        directory: "${config.users.users.${owner}.home}/${directory}"
      ) persistentDirectories;
    };
  flake.modules.darwin.slop = { inherit home-manager; };
}
