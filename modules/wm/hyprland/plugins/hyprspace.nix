{ inputs, lib, ... }:
{
  flake-file.inputs.hyprspace = {
    # Upstream includes the Lua migration and Hyprland 0.57 compatibility.
    url = "github:KZDKM/Hyprspace/8345bf6f623d486ca3f87f416ccf1412416eef08";
    inputs = {
      hyprland.follows = "hyprland";
      systems.follows = "systems";
    };
  };

  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    let
      inline = lib.generators.mkLuaInline;
      hyprspace = inputs.hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace;
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
