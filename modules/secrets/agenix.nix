{ inputs, ... }:
let
  mkAgenixModule =
    agenixModule: rekeyModule:
    { config, ... }:
    {
      imports = [
        agenixModule
        rekeyModule
      ];

      age.rekey = {
        storageMode = "local";
        masterIdentities = [ ../../.secrets/identity.age ];
        localStorageDir = ../../.secrets/${config.networking.hostName};
      };
    };
in
{
  flake.modules.nixos.agenix = mkAgenixModule inputs.agenix.nixosModules.default inputs.agenix-rekey.nixosModules.default;
  flake.modules.darwin.agenix = {
    imports = [
      (mkAgenixModule inputs.agenix.darwinModules.default inputs.agenix-rekey.darwinModules.default)
    ];
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
