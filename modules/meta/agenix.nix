{
  inputs,
  self,
  ...
}:
{
  flake.agenix-rekey = inputs.agenix-rekey.configure {
    userFlake = self;
    inherit (self) nixosConfigurations darwinConfigurations;
  };

  gitignore = [
    "!/.secrets/"
  ];

  perSystem =
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
