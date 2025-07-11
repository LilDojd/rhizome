{
  flake.modules.homeManager.base =
    { pkgs, ... }:

    let
      overlayBtop = final: prev: {
        btop = prev.btop.override {
          rocmSupport = final.stdenv.isLinux;
          cudaSupport = final.stdenv.isLinux;
        };
      };

      pkgs' = pkgs.extend overlayBtop;
    in
    {
      programs.btop = {
        enable = true;
        package = pkgs'.btop;

        settings = {
          vim_keys = true;
          rounded_corners = true;
          proc_tree = true;
          show_gpu_info = "on";
          show_uptime = true;
          show_coretemp = true;
          cpu_sensor = "auto";
          show_disks = true;
          only_physical = true;
          io_mode = true;
          io_graph_combined = false;
        };
      };
    };
}
