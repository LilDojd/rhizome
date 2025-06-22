_: {
  flake.modules = {
    darwin.pc = {
      config.homebrew.casks = [ "zotero" ];
    };
    nixos.pc =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ zotero ];
      };
  };
}
