_: {
  flake.modules = {
    darwin.foundation = {
      config.homebrew.casks = [ "zotero" ];
    };
    nixos.foundation =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ zotero ];
      };
  };
}
