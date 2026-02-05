{
  nixpkgs.config.allowUnfreePackages = [ "davinci-resolve-studio" ];
  flake.modules.nixos.foundation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.davinci-resolve-studio ];
    };
}
