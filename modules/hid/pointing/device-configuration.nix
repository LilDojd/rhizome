{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      services.ratbagd.enable = true;
      environment.systemPackages = [ pkgs.piper ];
    };
}
