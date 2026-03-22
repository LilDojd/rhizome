{ inputs, lib, ... }:
{
  systems = import inputs.systems |> lib.filter (s: s != "x86_64-darwin");
}
