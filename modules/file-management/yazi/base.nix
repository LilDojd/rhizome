_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        atool
        du-dust
        fd
        file
        ripgrep
        ripgrep-all
        unzip
        tokei
      ];
      programs = {
        yazi = {
          enable = true;
          enableFishIntegration = true;
          plugins = {
            inherit (pkgs.yaziPlugins) lazygit;
            inherit (pkgs.yaziPlugins) full-border;
            inherit (pkgs.yaziPlugins) smart-enter;
          };
          initLua = ''
            			require("full-border"):setup()
                  require("smart-enter"):setup {
                    open_multi = true,
                  }
            		'';
        };
        bat.enable = true;
      };
    };
}
