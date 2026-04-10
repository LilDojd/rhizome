{
  flake.modules.homeManager.linux =
    { config, ... }:
    {
      xdg = {
        enable = true;
        userDirs =
          let
            home = config.home.homeDirectory;
          in
          {
            enable = true;
            setSessionVariables = true;
            createDirectories = true;
            desktop = "${home}/Desktop";
            documents = "${home}/Documents";
            download = "${home}/Downloads";
            music = "${home}/Music";
            pictures = "${home}/Pictures";
            publicShare = "${home}/Public";
            templates = "${home}/Templates";
            videos = "${home}/Videos";
          };
      };
    };
}
