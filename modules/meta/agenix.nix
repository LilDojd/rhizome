{
  inputs,
  self,
  ...
}:
{
  flake.agenix-rekey = inputs.agenix-rekey.configure {
    userFlake = self;
    inherit (self) nixosConfigurations;
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
