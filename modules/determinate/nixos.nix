{ inputs, config, ... }:
{
  flake.modules.nixos.foundation = {
    imports = [ inputs.determinate.nixosModules.default ];
    environment.systemPackages = [ inputs.fh.packages."x86_64-linux".default ];
    environment.persistence."/persistent".users.${config.flake.meta.owner.username}.directories = [
      ".local/state/nix/profiles/channels"
    ];
  };
}
