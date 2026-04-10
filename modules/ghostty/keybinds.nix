{
  flake.modules.homeManager.gui.programs.ghostty.settings = {
    keybind = [
      # general
      "alt+s>r=reload_config"
      "alt+s>x=close_surface"
      "alt+s>n=new_window"

      # tabs
      "alt+s>c=new_tab"
      "alt+s>shift+l=next_tab"
      "alt+s>shift+h=previous_tab"
      "alt+s>comma=move_tab:-1"
      "alt+s>period=move_tab:1"

      # quick tab switch
      "alt+s>1=goto_tab:1"
      "alt+s>2=goto_tab:2"
      "alt+s>3=goto_tab:3"
      "alt+s>4=goto_tab:4"
      "alt+s>5=goto_tab:5"
      "alt+s>6=goto_tab:6"
      "alt+s>7=goto_tab:7"
      "alt+s>8=goto_tab:8"
      "alt+s>9=goto_tab:9"

      # splits
      "alt+s>\\=new_split:right"
      "alt+s>-=new_split:down"
      "alt+s>j=goto_split:bottom"
      "alt+s>k=goto_split:top"
      "alt+s>h=goto_split:left"
      "alt+s>l=goto_split:right"
      "alt+s>z=toggle_split_zoom"
      "alt+s>e=equalize_splits"

      # clipboard
      "ctrl+v=paste_from_clipboard"
    ];
  };
}
