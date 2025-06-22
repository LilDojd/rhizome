{ lib, ... }:
{
  flake.modules.homeManager.base =
    {
      programs.tmux.extraConfig = lib.mkAfter ''
        ####### Custom key-bindings ########################################

        # Reload local configuration fast
        bind-key R run-shell 'tmux source-file ~/.config/tmux/tmux.conf >/dev/null; \
                              tmux display-message "reloaded ~/.config/tmux/tmux.conf"'

        # Quick window navigation
        bind C-n next-window
        bind C-p previous-window

        # Bracketed paste
        bind ] paste-buffer -p

        # Split panes, keeping current directory
        bind % split-window -h -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"
      '';
    };
}
