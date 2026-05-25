_: {
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings.window_rule = [
      {
        match.class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$";
        tag = "+file-manager";
      }
      {
        match.class = "^(com.mitchellh.ghostty|org.wezfurlong.wezterm|Alacritty|kitty|kitty-dropterm)$";
        tag = "+terminal";
      }
      {
        match.class = "^(Brave-browser(-beta|-dev|-unstable)?)$";
        tag = "+browser";
      }
      {
        match.class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$";
        tag = "+browser";
      }
      {
        match.class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$";
        tag = "+browser";
      }
      {
        match.class = "^([Tt]horium-browser|[Cc]achy-browser)$";
        tag = "+browser";
      }
      {
        match.class = "^(codium|codium-url-handler|VSCodium)$";
        tag = "+projects";
      }
      {
        match.class = "^(VSCode|code-url-handler)$";
        tag = "+projects";
      }
      {
        match.class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$";
        tag = "+im";
      }
      {
        match.class = "^([Ff]erdium)$";
        tag = "+im";
      }
      {
        match.class = "^([Ww]hatsapp-for-linux)$";
        tag = "+im";
      }
      {
        match.class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$";
        tag = "+im";
      }
      {
        match.class = "^(teams-for-linux)$";
        tag = "+im";
      }
      {
        match.class = "^(gamescope)$";
        tag = "+games";
      }
      {
        match.class = "^(steam_app_d+)$";
        tag = "+games";
      }
      {
        match.class = "^([Ss]team)$";
        tag = "+gamestore";
      }
      {
        match.title = "^([Ll]utris)$";
        tag = "+gamestore";
      }
      {
        match.class = "^(com.heroicgameslauncher.hgl)$";
        tag = "+gamestore";
      }
      {
        match.class = "^(gnome-disks|wihotspot(-gui)?)$";
        tag = "+settings";
      }
      {
        match.class = "^([Rr]ofi)$";
        tag = "+settings";
      }
      {
        match.class = "^(file-roller|org.gnome.FileRoller)$";
        tag = "+settings";
      }
      {
        match.class = "^(nm-applet|nm-connection-editor|blueman-manager)$";
        tag = "+settings";
      }
      {
        match.class = "^(pavucontrol|pwvcucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$";
        tag = "+settings";
      }
      {
        match.class = "^(nwg-look|qt5ct|qt6ct|[Yy]ad)$";
        tag = "+settings";
      }
      {
        match.class = "(xdg-desktop-portal-gtk)";
        tag = "+settings";
      }
      {
        match.class = "(.blueman-manager-wrapped)";
        tag = "+settings";
      }
      {
        match.class = "(nwg-displays)";
        tag = "+settings";
      }

      {
        match.title = "^(Picture-in-Picture)$";
        move = "72% 7%";
      }
      {
        match.class = "^([Ff]erdium)$";
        center = true;
      }
      {
        match.class = "^([Ww]aypaper)$";
        float = true;
      }
      {
        match.class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$";
        center = true;
      }
      {
        match.class = "([Tt]hunar)";
        match.title = "negative:(.*[Tt]hunar.*)";
        center = true;
      }
      {
        match.title = "^(Authentication Required)$";
        center = true;
      }
      {
        match.class = "(1Password)";
        match.float = true;
        center = true;
      }

      {
        match.class = "^(.*)$";
        idle_inhibit = "fullscreen";
      }
      {
        match.title = "^(.*)$";
        idle_inhibit = "fullscreen";
      }
      {
        match.fullscreen = true;
        idle_inhibit = "fullscreen";
      }

      {
        match.tag = "settings*";
        float = true;
      }
      {
        match.class = "^([Ff]erdium)$";
        float = true;
      }
      {
        match.title = "^(Picture-in-Picture)$";
        float = true;
      }
      {
        match.class = "^(mpv|com.github.rafostar.Clapper)$";
        float = true;
      }
      {
        match.title = "^(Authentication Required)$";
        float = true;
      }
      {
        match.class = "(codium|codium-url-handler|VSCodium)";
        match.title = "negative:(.*codium.*|.*VSCodium.*)";
        float = true;
      }
      {
        match.class = "^(com.heroicgameslauncher.hgl)$";
        match.title = "negative:(Heroic Games Launcher)";
        float = true;
      }
      {
        match.class = "^([Ss]team)$";
        match.title = "negative:^([Ss]team)$";
        float = true;
      }
      {
        match.class = "([Tt]hunar)";
        match.title = "negative:(.*[Tt]hunar.*)";
        float = true;
      }
      {
        match.initial_title = "(Add Folder to Workspace)";
        float = true;
      }
      {
        match.initial_title = "(Open Files)";
        float = true;
      }
      {
        match.initial_title = "(wants to save)";
        float = true;
      }

      {
        match.initial_title = "(Open Files)";
        size = "70% 60%";
      }
      {
        match.initial_title = "(Add Folder to Workspace)";
        size = "70% 60%";
      }
      {
        match.tag = "settings*";
        size = "70% 70%";
      }
      {
        match.class = "^([Ff]erdium)$";
        size = "60% 70%";
      }

      {
        match.tag = "browser*";
        opacity = "1.0 1.0";
      }
      {
        match.tag = "projects*";
        opacity = "0.9 0.8";
      }
      {
        match.tag = "im*";
        opacity = "0.94 0.86";
      }
      {
        match.tag = "file-manager*";
        opacity = "0.9 0.8";
      }
      {
        match.tag = "terminal*";
        opacity = "0.9 0.8";
      }
      {
        match.tag = "settings*";
        opacity = "0.9 0.8";
      }
      {
        match.class = "^(gedit|org.gnome.TextEditor|mousepad)$";
        opacity = "0.9 0.8";
      }
      # seahorse = gnome-keyring gui
      {
        match.class = "^(seahorse)$";
        opacity = "0.9 0.8";
      }
      {
        match.title = "^(Picture-in-Picture)$";
        opacity = "0.95 0.75";
      }

      {
        match.title = "^(Picture-in-Picture)$";
        pin = true;
      }
      {
        match.title = "^(Picture-in-Picture)$";
        keep_aspect_ratio = true;
      }

      {
        match.tag = "games*";
        no_blur = true;
      }
      {
        match.class = "^(blender)$";
        suppress_event = "maximize";
      }
      {
        match.class = "^(blender)$";
        no_anim = true;
      }
      {
        match.tag = "games*";
        fullscreen = true;
      }
    ];
  };
}
