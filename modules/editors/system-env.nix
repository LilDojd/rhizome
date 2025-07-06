{
  flake.modules =
    let
      defaultEditor = {
        environment.variables.EDITOR = "hx";
      };
    in
    {
      nixos.foundation = defaultEditor;
      darwin.foundation = defaultEditor;
    };
}
