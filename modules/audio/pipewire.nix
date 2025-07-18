{
  flake.modules = {
    nixos.foundation = {
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
      security.rtkit.enable = true;
    };

    homeManager.hyprland =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          pwvucontrol
          qpwgraph
        ];
      };
  };
}
