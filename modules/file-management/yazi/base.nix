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
            lazygit = pkgs.yaziPlugins.lazygit;
            full-border = pkgs.yaziPlugins.full-border;
            git = pkgs.yaziPlugins.git;
            smart-enter = pkgs.yaziPlugins.smart-enter;
          };
          initLua = ''
            			require("full-border"):setup()
                  require("git"):setup()
                  require("smart-enter"):setup {
                    open_multi = true,
                  }
            		'';
        };
        bat.enable = true;
      };
    };
}
