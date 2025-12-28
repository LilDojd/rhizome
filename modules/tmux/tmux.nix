{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv) isDarwin;
      inherit (lib) optionals optionalString;
    in
    {
      programs.tmux = {
        enable = true;
        shortcut = "q";
        mouse = true;
        escapeTime = 10;
        keyMode = "vi";
        terminal = "tmux-256color";
        historyLimit = 50000;
        plugins = lib.attrValues {
          inherit (pkgs.tmuxPlugins)
            battery
            copycat
            cpu
            open
            prefix-highlight
            resurrect
            ;
        };
        extraConfig = optionalString isDarwin ''
          set -g default-command "reattach-to-user-namespace -l $SHELL"
        '';
      };

      home.packages = [ pkgs.tmux-xpanes ] ++ optionals isDarwin [ pkgs.reattach-to-user-namespace ];
    };
}
