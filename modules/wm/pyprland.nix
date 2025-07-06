{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ pyprland ];

      home.file.".config/hypr/pyprland.toml".text = ''
        [pyprland]
        plugins = [
          "scratchpads",
        ]

        [scratchpads.term]
        animation = "fromTop"
        command = "ghostty --class=com.mitchellh.ghostty-dropterm"
        class = "com.mitchellh.ghostty-dropterm"
        size = "70% 70%"
          max_size = "1920px 100%"
          position = "150px 150px"
      '';
    };
}
