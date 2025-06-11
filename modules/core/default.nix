{ inputs, ... }: {
  imports = [
    ./greetd.nix
    ./nh.nix
    ./boot.nix
    ./system.nix
    ./services.nix
    ./hardware.nix
    ./xserver.nix
    ./network.nix
    ./packages.nix
    ./stylix.nix
    ./user.nix
    inputs.stylix.nixosModules.stylix
  ];
}
