{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.file = {
        "./backgrounds/spacegoose.png".source = ./spacegoose.png;
        "./backgrounds/colorful-planets.jpg".source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/colorful-planets.jpg";
          sha256 = "090rf9ihb1f8ngnhw1zgn1f7vz73khp1cyn3p01q9d7c67pnp03g";
        };
        "./backgrounds/earth.png".source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/earth.png";
          sha256 = "18d89kz5n69zvqklzwrwkvpwjv4msywwrrrrk580r3lchzfrrdv8";
        };
        "./backgrounds/pixel-earth.png".source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/D3Ext/aesthetic-wallpapers/main/images/pixel-earth.png";
          sha256 = "0im7vj61nr6v3kgkgg099n6lawwwm6061ih3lmfkc8jh646imk52";
        };
        "./backgrounds/nix-black-4k.png".source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/refs/heads/main/os/nix-black-4k.png";
          sha256 = "144mz3nf6mwq7pmbmd3s9xq7rx2sildngpxxj5vhwz76l1w5h5hx";
        };
      };
    };
}
