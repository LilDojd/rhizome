{inputs, ...}:
let
  blenderModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ blender_4_4 ];
    };

in
{
  nixpkgs.overlays = [
    inputs.blender.overlays.default
  ]
  ;
  flake.modules = {
    nixos.foundation = blenderModule;
    darwin.foundation = blenderModule;
  };
}
