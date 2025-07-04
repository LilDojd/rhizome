{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {

      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
