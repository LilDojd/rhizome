{
  flake.modules.homeManager.linux =
    { pkgs, ... }:
    let
      mpv-wayland = pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          uosc
          sponsorblock
        ];

      };
    in
    {
      programs.mpv = {
        enable = true;

        package = mpv-wayland;

        config = {
          gpu-context = "wayland";
          profile = "high-quality";
          ytdl-format = "bestvideo+bestaudio";
          cache-default = 4000000;
        };
      };
    };
}
