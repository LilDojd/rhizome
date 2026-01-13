{ inputs, ... }:
{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      systemd.user.services.clipboard-sync = {
        description = "Synchronize clipboards across all displays";
        documentation = [ "https://github.com/dnut/clipboard-sync/" ];
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        requisite = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${
            inputs.clipboard-sync.packages.${pkgs.stdenv.hostPlatform.system}.default
          }/bin/clipboard-sync --hide-timestamp --log-level debug";
          Restart = "on-failure";
        };
      };
    };
}
