{
  flake.modules.homeManager.gui.programs.ghostty.settings = {
    macos-option-as-alt = "left";
    adjust-cell-height = "10%";
    wait-after-command = false;
    shell-integration = "detect";
    shell-integration-features = "cursor,sudo,title,ssh-env,ssh-terminfo";
    copy-on-select = "clipboard";
    app-notifications = "no-clipboard-copy";
    quick-terminal-position = "center";
    linux-cgroup = "single-instance";
  };
}
