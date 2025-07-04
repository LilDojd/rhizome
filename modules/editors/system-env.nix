{
  flake.modules =
    let
      defaultEditor = {
        environment.variables.EDITOR = "hx";
      };
    in
    {
      nixos.pc = defaultEditor;
      darwin.pc = defaultEditor;
    };
}
