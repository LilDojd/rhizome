{
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        lutris
      ];
    };
}
