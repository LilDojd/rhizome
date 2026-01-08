{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        atool
        dust
        fd
        file
        ripgrep
        ripgrep-all
        unzip
        tokei
        ffmpeg
        imagemagick
        poppler-utils
        jq
        p7zip
        resvg
        exiftool
        mediainfo
      ];
      programs = {
        yazi = {
          enable = true;
          enableFishIntegration = true;
          plugins = {
            inherit (pkgs.yaziPlugins) lazygit;
            inherit (pkgs.yaziPlugins) full-border;
            inherit (pkgs.yaziPlugins) smart-enter;
            inherit (pkgs.yaziPlugins) mime-ext;
          };
          initLua = ''
            			require("full-border"):setup()
            			require("mime-ext"):setup()
                  require("smart-enter"):setup {
                    open_multi = true,
                  }
            		'';
        };
        bat.enable = true;
      };
    };
}
