{
  flake.modules.darwin.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ uv ];
      environment.variables.UV_PYTHON_DOWNLOADS = "never";
    };
}
