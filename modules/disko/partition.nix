{
  flake.modules = {
    nixos.pc = import ./_btrfs.nix;
  };
}
