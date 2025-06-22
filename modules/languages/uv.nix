{
  flake.modules.darwin.pc =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ uv ];
      environment.variables.UV_PYTHON_DOWNLOADS = "never";
    };
}
