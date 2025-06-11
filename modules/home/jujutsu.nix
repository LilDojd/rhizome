{ pkgs, ... }: {
  programs.jujutsu = {
    enable = true;
    package = pkgs.jujutsu;
    settings = {
      user = {
        email = "yawner@pm.me";
        name = "LilDojd";
      };
      colors = {
        change_id = "#04a5e5";
        commit_id = {
          fg = "#40a02b";
          bold = true;
        };
      };
      ui = {
        editor = "hx";
        pager = "delta";
      };
      git = { private-commits = "description(glob:'private:*')"; };
    };
  };
}
