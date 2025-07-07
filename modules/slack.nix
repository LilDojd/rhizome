_: {
  flake.modules = {
    nixos.foundation =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ slack ];
      };
  };
  nixpkgs.allowedUnfreePackages = [ "slack" ];
}
