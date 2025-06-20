{ inputs, ... }:
{
  flake.modules.darwin.pc =
    let
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
    in
    {
      imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
      config = {
        nix-homebrew = {
          enable = true;
          mutableTaps = false;
          inherit taps;
        };

        homebrew = {
          enable = true;
          global.autoUpdate = false;
          onActivation = {
            upgrade = true;
            # 'zap': uninstalls all formulae (and related files) not listed here.
            cleanup = "zap";
          };

          # If we don't do this, nix-darwin may attempt to remove our taps even
          # when they are managed by nix-homebrew.
          taps = builtins.attrNames taps;

          casks = [ ];

        };
      };

    };
}
