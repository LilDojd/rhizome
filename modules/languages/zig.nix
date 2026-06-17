{
  flake.modules = {
    homeManager.base =
      { ... }:
      {
        programs.helix = {
          languages = {
            language = [
              {
                name = "zig";
                language-servers = [ "zls" ];
                auto-format = true;
                auto-pairs = {
                  "(" = ")";
                  "{" = "}";
                  "[" = "]";
                  "\"" = ''"'';
                  "`" = "`";
                  "<" = ">";
                };
              }
            ];
            language-server.zls.config.zls.enable_build_on_save = true;
          };
        };
      };
  };
}
