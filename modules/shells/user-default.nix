_: {
  flake.modules = {
    nixos.foundation =
      { pkgs, ... }:
      {
        programs.zsh.enable = true;
        users.defaultUserShell = pkgs.zsh;
      };

    # Nix-darwin does not currently have a clear way to control users shell

  };
}
