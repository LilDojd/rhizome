{ config, ... }:
{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            user = config.flake.meta.owner.username;
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          };
        };
      };
    };
}
