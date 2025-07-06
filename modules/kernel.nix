{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {

      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
