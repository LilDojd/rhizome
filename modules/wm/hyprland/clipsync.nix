{ inputs, ... }:
{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    let
      clipboard-sync = pkgs.rustPlatform.buildRustPackage {
        pname = "clipboard-sync";
        version = "0.2.0";
        src = inputs.clipboard-sync;
        cargoLock.lockFile = "${inputs.clipboard-sync}/Cargo.lock";
        buildInputs = [ pkgs.libxcb ];
      };
    in
    {
      systemd.user.services.clipboard-sync = {
        description = "Synchronize clipboards across all displays";
        documentation = [ "https://github.com/dnut/clipboard-sync/" ];
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        requisite = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${clipboard-sync}/bin/clipboard-sync --hide-timestamp --log-level debug";
          Restart = "on-failure";
        };
      };
    };
}
