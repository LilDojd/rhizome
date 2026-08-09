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
    homeManager.gui.stylix.targets.obsidian.vaultNames = [ "vault" ];
  };
}
