{
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.foundation =
    nixosArgs@{ pkgs, ... }:
    {
      services.greetd = {
        enable = true;

        settings.default_session = {
          command = "${lib.getExe pkgs.tuigreet} --cmd ${lib.getExe' nixosArgs.config.programs.hyprland.package "start-hyprland"}";
          user = config.flake.meta.owner.username;
        };
      };
    };
}
