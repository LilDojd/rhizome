{

  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    let
      task-waybar = pkgs.writeShellScriptBin "task-waybar" ''
        sleep 0.1
        ${pkgs.swaynotificationcenter}/bin/swaync-client -t &
      '';
    in
    {
      home.packages = [ task-waybar ];
    };
}
