{
  flake.modules =
    { pkgs, ... }:
    {
      nixos.pc = {
        environment.localBinInPath = true;
        environment.variables.UV_PYTHON_DOWNLOADS = "never";
        environment.systemPackages = with pkgs; [ uv ];
      };
      darwin.pc = {
        environment.variables.UV_PYTHON_DOWNLOADS = "never";
        environment.systemPackages = with pkgs; [ uv ];
      };
    };
}
