{
  flake.modules.homeManager.base =
    { config, pkgs, ... }:
    let
      wasmPlugin =
        {
          pname,
          version,
          url,
          hash,
        }:
        pkgs.stdenvNoCC.mkDerivation {
          inherit pname version;
          src = pkgs.fetchurl { inherit url hash; };
          phases = [ "buildPhase" ];
          buildPhase = "cp $src $out";
        };
      attention = wasmPlugin {
        pname = "zellij-attention";
        version = "0.3.1";
        url = "https://github.com/KiryuuLight/zellij-attention/releases/download/v0.3.1/zellij-attention.wasm";
        hash = "sha256-QgkzerYacxRI7HMzYvPvaZqQW7tcARKpOm1hY2D9ci8=";
      };
      sessionizer = wasmPlugin {
        pname = "zellij-sessionizer";
        version = "0.5.0";
        url = "https://github.com/laperlej/zellij-sessionizer/releases/download/v0.5.0/zellij-sessionizer.wasm";
        hash = "sha256-xBhBwCPnToH5mg/Y2V4FBO0gLfLNuSYE31HJ5OoLoFs=";
      };
      room = wasmPlugin {
        pname = "room";
        version = "1.2.1";
        url = "https://github.com/rvcas/room/releases/download/v1.2.1/room.wasm";
        hash = "sha256-kLSDpAt2JGj7dYYhYFh6BfvtzVwTrcs+0jHwG/nActE=";
      };
      forgot = wasmPlugin {
        pname = "zellij-forgot";
        version = "0.4.2";
        url = "https://github.com/karimould/zellij-forgot/releases/download/0.4.2/zellij_forgot.wasm";
        hash = "sha256-MRlBRVGdvcEoaFtFb5cDdDePoZ/J2nQvvkoyG6zkSds=";
      };
      pluginDir = "${config.xdg.configHome}/zellij/plugins";
      home = config.home.homeDirectory;
    in
    {
      stylix.targets.zellij.enable = true;

      xdg.configFile = {
        "zellij/plugins/forgot.wasm".source = forgot;
        "zellij/plugins/room.wasm".source = room;
        "zellij/plugins/sessionizer.wasm".source = sessionizer;
        "zellij/plugins/zjstatus.wasm".source = pkgs.zellijPlugins.zjstatus;
      };

      programs.zellij = {
        enable = true;
        enableFishIntegration = true;
        attachExistingSession = true;
        exitShellOnExit = true;
        plugins = [
          pkgs.zellijPlugins.autolock
          attention
        ];

        settings = {
          default_layout = "default";
          mouse_mode = true;
          scroll_buffer_size = 50000;
          show_startup_tips = false;
          show_release_notes = false;

          plugins = {
            autolock = {
              is_enabled = "true";
              triggers = "hx|helix|nvim|vim|vi|yazi|lazygit|jjui|fzf|btop|less|man";
              reaction_seconds = "0.3";
            };
            attention.enabled = "true";
          };
        };

        layouts.default = ''
          layout {
              pane
              pane size=1 borderless=true {
                  plugin location="file:${pluginDir}/zjstatus.wasm" {
                      format_left "{mode} #[bold]{session} {tabs}"
                      format_right "{datetime}"
                      format_space ""

                      mode_normal "#[fg=blue,bold] {name} "
                      mode_locked "#[fg=red,bold] {name} "
                      mode_tmux "#[fg=yellow,bold] {name} "

                      tab_normal " {index}:{name} "
                      tab_active "#[bold] {index}:{name}* "

                      datetime " {format} "
                      datetime_format "%H:%M"
                  }
              }
          }
        '';

        extraConfig = ''
          keybinds {
              tmux {
                  bind "Q" { Quit; }
                  bind "?" {
                      LaunchOrFocusPlugin "file:${pluginDir}/forgot.wasm" {
                          floating true
                      }
                      SwitchToMode "Normal"
                  }
                  bind "g" {
                      LaunchOrFocusPlugin "file:${pluginDir}/sessionizer.wasm" {
                          floating true
                          move_to_focused_tab true
                          cwd "/"
                          root_dirs "${home}/Projects;${home}/repos;${home}/work;${home}/personal;${home}/rhizome-workspaces"
                          individual_dirs "${home}/rhizome"
                      }
                      SwitchToMode "Normal"
                  }
                  bind "f" {
                      LaunchOrFocusPlugin "file:${pluginDir}/room.wasm" {
                          floating true
                          ignore_case true
                          quick_jump true
                      }
                      SwitchToMode "Normal"
                  }
              }
          }
        '';
      };
    };
}
