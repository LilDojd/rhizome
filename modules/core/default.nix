{ inputs, ... }: {
  imports = [
    ./greetd.nix
    ./nh.nix
    ./boot.nix
    ./system.nix
    ./services.nix
    ./user.nix
    ./hardware.nix
    ./xserver.nix
    ./network.nix
    ./packages.nix
    ./stylix.nix
    inputs.stylix.nixosModules.stylix
  ];
}
