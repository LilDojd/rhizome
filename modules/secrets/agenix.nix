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
  flake-file.inputs.agenix = {
    url = "github:ryantm/agenix";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager";
      darwin.follows = "nix-darwin";
    };
  };

  flake.modules.nixos.agenix = mkAgenixModule inputs.agenix.nixosModules.default inputs.agenix-rekey.nixosModules.default;
  flake.modules.darwin.agenix =
    { lib, ... }:
    {
      imports = [
        (mkAgenixModule inputs.agenix.darwinModules.default inputs.agenix-rekey.darwinModules.default)
      ];

      # nix-darwin users have no `group`, which agenix reads for the default.
      options.age.secrets = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule { group = lib.mkDefault "staff"; });
      };

      config.age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
}
