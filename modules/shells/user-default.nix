_: {
  flake.modules = {
    nixos.pc =
      { pkgs, ... }:
      {
        programs.bash.enable = true;
        users.defaultUserShell = pkgs.bash;
      };

    # Nix-darwin does not currently have a clear way to control users shell

  };
}
