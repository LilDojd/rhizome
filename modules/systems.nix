{ inputs, lib, ... }:
let
  excluded = [
    "x86_64-darwin"
    "aarch64-linux"
  ];
in
{
  systems = import inputs.systems |> lib.filter (s: !(lib.elem s excluded));
}
