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
              }
            ];
            language-server.zls.config.zls = {
              enable_build_on_save = true;
              warn_style = true;
              inlay_hints_hide_redundant_param_names = true;
              inlay_hints_hide_redundant_param_names_last_token = true;
            };
          };
        };
      };
  };
}
