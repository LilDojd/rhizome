{
  flake.modules.nixos."nixosConfigurations/darkforest" =
    { config, ... }:
    {
      services.ucodenix = {
        enable = true;
        cpuModelId = config.facter.reportPath;
      };
    };
}
