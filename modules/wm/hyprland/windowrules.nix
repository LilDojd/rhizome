{ lib, ... }:
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings.window_rule = lib.mkAfter [
      {
        match.title = "^(Picture-in-Picture)$";
        move = "72% 7%";
      }
      {
        match.title = "^(Authentication Required)$";
        center = true;
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
        match.title = "^(Picture-in-Picture)$";
        float = true;
      }
      {
        match.title = "^(Authentication Required)$";
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
        match.tag = "games*";
        fullscreen = true;
        confine_pointer = true;
      }
      {
        match.content = "game";
        match.fullscreen = true;
        confine_pointer = true;
      }
    ];
  };
}
