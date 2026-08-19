{ inputs, lib, ... }:
{
  flake.modules.homeManager.hyprland =
    hmArgs@{ pkgs, ... }:
    let
      inline = lib.generators.mkLuaInline;
      hyprland = hmArgs.config.wayland.windowManager.hyprland.package;
      hyprspace =
        inputs.hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace.overrideAttrs
          (old: {
            buildInputs = builtins.filter (input: lib.getName input != "hyprland") old.buildInputs ++ [
              hyprland
            ];
          });
    in
    {
      wayland.windowManager.hyprland = {
        plugins = [ hyprspace ];
        settings.bind = [
          {
            _args = [
              (inline ''modifier .. " + TAB"'')
              (inline "function() hl.plugin.overview.toggle() end")
            ];
          }
        ];
      };
    };
}
