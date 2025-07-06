let
  blenderModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ blender ];
    };

in
{
  flake.modules = {
    nixos.foundation = blenderModule;
    darwin.foundation = blenderModule;
  };
}
