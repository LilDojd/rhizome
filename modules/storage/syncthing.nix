{ config, ... }:
let
  username = config.flake.meta.owner.username;
in
{
  flake.modules.nixos.agenix.age.secrets.syncthingGuiPassword.rekeyFile = ./syncthingGuiPassword.age;

  flake.modules.nixos.foundation =
    { config, ... }:
    {
      environment.persistence."/persistent".users.${username}.directories = [
        "Sync"
        ".config/syncthing"
      ];
      services.syncthing = {
        enable = true;
        user = username;
        group = "users";
        dataDir = "/home/${username}/Sync";
        configDir = "/home/${username}/.config/syncthing";
        openDefaultPorts = true;
        guiAddress = "127.0.0.1:8384";
        settings.gui.user = username;
        guiPasswordFile = config.age.secrets.syncthingGuiPassword.path;
      };
    };

  flake.modules.homeManager.linux =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "syncthing-gui";
          runtimeInputs = [ pkgs.xdg-utils ];
          text = ''
            xdg-open http://localhost:8384
          '';
        })
      ];
      xdg.desktopEntries.syncthing-gui = {
        name = "Syncthing";
        genericName = "File Synchronization";
        exec = "syncthing-gui";
        terminal = false;
        categories = [
          "Network"
          "FileTransfer"
        ];
        icon = "syncthing";
        type = "Application";
      };
    };
}
