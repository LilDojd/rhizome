_: {
  flake.modules = {
    darwin.foundation = {
      config.homebrew.casks = [ "zotero" ];
    };
    nixos.foundation =
      { pkgs, ... }:
      let
        # TODO: Remove when Nixpkgs Zotero uses its upstream-supported Gecko runtime.
        gecko = (
          pkgs.firefox-bin-unwrapped.override {
            generated = {
              version = "140.15.0esr";
              sources = [
                {
                  arch = "linux-x86_64";
                  locale = "en-US";
                  url = "https://archive.mozilla.org/pub/firefox/releases/140.15.0esr/linux-x86_64/en-US/firefox-140.15.0esr.tar.xz";
                  sha256 = "sha256-yTquYQ8Rd9962ngjve9DPe1P9r/k5rrtppQav06ZLz8=";
                }
              ];
            };
          }
        );
      in
      {
        environment.systemPackages = [
          ((pkgs.zotero.override { firefox-esr-153-unwrapped = gecko; }).overrideAttrs (old: {
            buildPhase =
              builtins.replaceStrings [ "${gecko}/lib/firefox" ] [ "${gecko}/lib/${gecko.libName}" ]
                old.buildPhase;
          }))
        ];
      };
  };
}
