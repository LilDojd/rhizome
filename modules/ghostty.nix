{
  flake.modules.darwin.foundation = {
    config.homebrew.casks = [ "ghostty" ];
  };
  flake.modules.homeManager.gui =
    hmArgs@{ pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;
      };
      home.file."./.config/ghostty/config".text = ''

        theme = Catppuccin Macchiato

        adjust-cell-height = 10%
        window-theme = dark
        window-height = 32
        window-width = 110
        background-opacity = 0.95
        background-blur-radius = 60
        selection-background = #2d3f76
        selection-foreground = #c8d3f5
        cursor-style = bar
        mouse-hide-while-typing = true

        # keybindings
        keybind = alt+s>r=reload_config
        keybind = alt+s>x=close_surface

        keybind = alt+s>n=new_window

        # tabs
        keybind = alt+s>c=new_tab
        keybind = alt+s>shift+l=next_tab
        keybind = alt+s>shift+h=previous_tab
        keybind = alt+s>comma=move_tab:-1
        keybind = alt+s>period=move_tab:1

        # quick tab switch
        keybind = alt+s>1=goto_tab:1
        keybind = alt+s>2=goto_tab:2
        keybind = alt+s>3=goto_tab:3
        keybind = alt+s>4=goto_tab:4
        keybind = alt+s>5=goto_tab:5
        keybind = alt+s>6=goto_tab:6
        keybind = alt+s>7=goto_tab:7
        keybind = alt+s>8=goto_tab:8
        keybind = alt+s>9=goto_tab:9

        # split
        keybind = alt+s>\=new_split:right
        keybind = alt+s>-=new_split:down

        keybind = alt+s>j=goto_split:bottom
        keybind = alt+s>k=goto_split:top
        keybind = alt+s>h=goto_split:left
        keybind = alt+s>l=goto_split:right

        keybind = alt+s>z=toggle_split_zoom

        keybind = alt+s>e=equalize_splits

        font-size = 12
        font-family = ${hmArgs.config.stylix.fonts.monospace.name}

        font-variation = "wght=200"
        font-variation = "wdth=100"
        font-variation = "slnt=0"

        font-variation-bold = "wght=300"
        font-variation-bold = "wdth=100"
        font-variation-bold = "slnt=0"

        font-variation-bold-italic = "wght=300"
        font-variation-bold-italic = "wdth=100"
        font-variation-bold-italic = "slnt=-9.625"

        font-variation-italic = "wght=300"
        font-variation-italic = "wdth=100"
        font-variation-italic = "slnt=-9.625"

        font-feature = "calt"
        font-feature = "ss01"
        font-feature = "ss02"
        font-feature = "ss03"
        font-feature = "ss04"
        font-feature = "ss05"
        font-feature = "ss06"
        font-feature = "ss07"
        font-feature = "ss08"
        font-feature = "ss09"
        font-feature = "ss10"
        font-feature = "liga"

        wait-after-command = false
        shell-integration = detect
        window-save-state = always
        gtk-single-instance = true
        unfocused-split-opacity = 0.5
        quick-terminal-position = center
        shell-integration-features = cursor,sudo

        copy-on-select = clipboard
        app-notifications = no-clipboard-copy
        keybind = ctrl+v=paste_from_clipboard
      '';
    };
}
