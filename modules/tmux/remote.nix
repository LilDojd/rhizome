{
  flake.modules.homeManager.base =
    let
      # Thanks: https://github.com/DanielFGray/dotfiles/blob/master/tmux.remote.conf
      remoteConf = builtins.toFile "tmux.remote.conf" ''
        unbind C-q
        unbind q
        set-option -g prefix C-s
        bind s send-prefix
        bind C-s last-window
        set-option -g status-position top
      '';
    in
    {
      programs.tmux.extraConfig = ''
        if-shell "[ -n '$SSH_CONNECTION' ]" "source-file '${remoteConf}'"
      '';
    };
}
