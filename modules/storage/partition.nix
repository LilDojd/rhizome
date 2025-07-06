{
  inputs,
  ...
}:
{
  flake.modules.nixos.foundation = {
    imports = [ inputs.disko.nixosModules.disko ];
  };
}
