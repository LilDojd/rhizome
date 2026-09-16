{ inputs, lib, ... }:
let
  excluded = [
    "x86_64-darwin"
    "aarch64-linux"
  ];
in
{
  flake-file.inputs.systems.url = "github:nix-systems/default";

  systems = import inputs.systems |> lib.filter (s: !(lib.elem s excluded));
}
