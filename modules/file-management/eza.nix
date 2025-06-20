{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      l = lib.concatStringsSep " " [
        "${pkgs.eza}/bin/eza"
        "--group"
        "--icons"
        "--git"
        "--header"
        "--all"
      ];
    in
    {
      programs.eza = {
        enable = true;
        extraOptions = [
          "--group-directories-first"
          "--no-quotes"
          "--header" # Show header row
          "--git-ignore"
          "--icons=always"
          "--classify" # append indicator (/, *, =, @, |)
          "--hyperlink" # make paths clickable in some terminals
        ];
        icons = "auto";
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        git = true;
      };
      home.shellAliases = {
        inherit l;
        ll = "${l} --long";
        lt = "${l} --tree";
        ls = "${l}";
      };
    };
}
