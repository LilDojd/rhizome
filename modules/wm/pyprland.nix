{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    let
      class = "kitty-dropterm";
    in
    {
      home.packages = with pkgs; [ pyprland ];

      home.file.".config/hypr/pyprland.toml".text = ''
        [pyprland]
        plugins = [
          "scratchpads",
        ]

        [scratchpads.term]
        animation = "fromTop"
        command = "kitty --class=${class}"
        class = ${class}
        size = "70% 70%"
          max_size = "1920px 100%"
          position = "150px 150px"
      '';
    };
}
