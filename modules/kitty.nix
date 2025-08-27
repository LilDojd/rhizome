{
  flake.modules.homeManager.gui =
    hmArgs@{ pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        package = pkgs.kitty;
        settings = {
          font_family = "family='${hmArgs.config.stylix.fonts.monospace.name}'";
          font_features = "Maple Mono NF +calt +ss01 +zero +cv01";
          disable_ligatures = "cursor";
          font_size = 12;
          wheel_scroll_min_lines = 1;
          middle_click_paste = true;
          window_padding_width = 4;
          confirm_os_window_close = 0;
          scrollback_lines = 10000;
          enable_audio_bell = false;
          mouse_hide_wait = 60;
          cursor_trail = 1;
          tab_fade = 1;
          active_tab_font_style = "bold";
          inactive_tab_font_style = "bold";
          tab_bar_edge = "top";
          tab_bar_margin_width = 0;
          tab_bar_style = "powerline";
          enabled_layouts = "splits";
          copy_on_select = "yes";
          clear_selection_on_clipboard_loss = "no";
        };
        extraConfig = ''
          # Clipboard
          map ctrl+shift+v        paste_from_selection
          map shift+insert        paste_from_selection

          # Scrolling
          map ctrl+shift+up        scroll_line_up
          map ctrl+shift+down      scroll_line_down
          map ctrl+shift+k         scroll_line_up
          map ctrl+shift+j         scroll_line_down
          map ctrl+shift+page_up   scroll_page_up
          map ctrl+shift+page_down scroll_page_down
          map ctrl+shift+home      scroll_home
          map ctrl+shift+end       scroll_end
          map ctrl+shift+h         show_scrollback

          # Window management
          map alt+n               new_window_with_cwd       #open in current dir
          #map alt+n              new_os_window             #opens term in $HOME
          map alt+w               close_window
          map ctrl+shift+enter    launch --location=hsplit
          map ctrl+shift+s        launch --location=vsplit
          map ctrl+shift+]        next_window
          map ctrl+shift+[        previous_window
          map ctrl+shift+f        move_window_forward
          map ctrl+shift+b        move_window_backward
          map ctrl+shift+`        move_window_to_top
          map ctrl+shift+1        first_window
          map ctrl+shift+2        second_window
          map ctrl+shift+3        third_window
          map ctrl+shift+4        fourth_window
          map ctrl+shift+5        fifth_window
          map ctrl+shift+6        sixth_window
          map ctrl+shift+7        seventh_window
          map ctrl+shift+8        eighth_window
          map ctrl+shift+9        ninth_window # Tab management
          map ctrl+shift+0        tenth_window
          map ctrl+shift+right    next_tab
          map ctrl+shift+left     previous_tab
          map ctrl+shift+t        new_tab
          map ctrl+shift+q        close_tab
          map ctrl+shift+l        next_layout
          map ctrl+shift+.        move_tab_forward
          map ctrl+shift+,        move_tab_backward

          # Miscellaneous
          map ctrl+shift+up      increase_font_size
          map ctrl+shift+down    decrease_font_size
          map ctrl+shift+backspace restore_font_size
        '';
      };
    };
}
