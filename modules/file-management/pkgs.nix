{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dust
        fd
        file
        gnutar
        nkf
        p7zip
        ripgrep
        ripgrep-all
        tokei
        unar
        unzip
        zip
        zstd
      ];
    };
}
