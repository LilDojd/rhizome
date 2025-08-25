{
  flake.modules.homeManager.linux = {
    programs.lazysql = {
      enable = true;
      settings = {
        database = {
          Name = "Development database";
          Provider = "postgres";
          DBName = "foo";
          URL = "postgres://yawner@localhost:5432/yawner";
        };
        application = {
          DefaultPageSize = 300;
          DisableSidebar = false;
          SidebarOverlay = false;
        };
      };
    };
  };
}
