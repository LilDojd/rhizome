{
  inputs,
  self,
  ...
}:
{
  flake-file.inputs.agenix-rekey = {
    url = "github:oddlama/agenix-rekey";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-parts.follows = "flake-parts";
    };
  };

  flake.agenix-rekey = inputs.agenix-rekey.configure {
    userFlake = self;
    inherit (self) nixosConfigurations darwinConfigurations;
  };

  gitignore = [
    "!/.secrets/"
  ];

  partitions.dev.module.perSystem =
    {
      inputs',
      ...
    }:
    {
      devshells.default.packages = [
        inputs'.agenix-rekey.packages.default
      ];
    };
}
