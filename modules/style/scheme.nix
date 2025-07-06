{ inputs, lib, ... }:
let
  polyModule.stylix = lib.mkDefault {
    base16Scheme = "${inputs.tinted-schemes}/base16/catppuccin-macchiato.yaml";
    polarity = "dark";
  };
in
{
  flake.modules = {
    nixos.foundation = polyModule;
    # darwin.foundation = polyModule;
    homeManager.base = polyModule;
  };
}
