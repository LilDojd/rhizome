{
  flake.modules.homeManager.linux = {
    programs.lazysql = {
      enable = true;
      settings = {
        database = [
          {
            Name = "Development database";
            Provider = "postgres";
            DBName = "yawner";
            URL = "postgres://yawner@localhost:5432?sslmode=disable";
          }
        ];
        application = {
          DefaultPageSize = 300;
          DisableSidebar = false;
          SidebarOverlay = false;
        };
      };
    };
  };
}
