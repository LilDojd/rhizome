{
  nixpkgs.config.allowUnfreePackages = [ "obsidian" ];
  flake.modules = {
    nixos.foundation =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          obsidian
        ];
      };
  };
}
