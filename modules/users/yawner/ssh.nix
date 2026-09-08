{ config, lib, ... }:
let
  username = config.flake.meta.owner.username;
  keys = {
    darwinforest = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESOx5jXSV+jeGmIpVO3ASIByLflNIhnkfAlmXOnMsXk Darwin";
    darkforest = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5MjiDocRb+weVa110Tap77wstRGpugqmyg7QUOpVj+ Darkforest";
  };
in
{
  flake.modules = {
    nixos."nixosConfigurations/darkforest".users.users.${username}.openssh.authorizedKeys.keys = [
      keys.darwinforest
    ];

    darwin."darwinConfigurations/darwinforest" = {
      services.openssh.enable = true;
      users.users.${username}.openssh.authorizedKeys.keys = [ keys.darkforest ];
    };

    homeManager.base =
      { osConfig, ... }:
      let
        hostName = osConfig.networking.hostName;
      in
      lib.mkIf (builtins.hasAttr hostName keys) {
        home.file.".ssh/rhizome.pub".text = keys.${hostName} + "\n";
        programs.ssh.settings = lib.mapAttrs' (
          peer: _:
          lib.nameValuePair "${peer} ${peer}.local" {
            HostName = "${peer}.local";
            User = username;
            IdentityFile = "~/.ssh/rhizome.pub";
            IdentitiesOnly = true;
          }
        ) (lib.filterAttrs (name: _: name != hostName) keys);
      };
  };
}
