{ config, lib, ... }:
let
  username = config.flake.meta.owner.username;
in
{
  # Automatic key visualization reads raw keyboard events. Limit the process
  # lifetime to the streaming dashboard, even though group membership persists.
  flake.modules.nixos.yawner.users.users.${username}.extraGroups = [ "input" ];

  flake.modules.homeManager.hyprland =
    {
      config,
      pkgs,
      ...
    }:
    let
      dashboardTarget = "stream-dashboard.target";
      managerUrl = "https://dashboard.twitch.tv/u/yawnere/stream-manager";
      hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";

      dashboardDnd = pkgs.writeShellApplication {
        name = "stream-dashboard-dnd";
        runtimeInputs = with pkgs; [
          coreutils
          swaynotificationcenter
        ];
        text = ''
          state_dir="''${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set}/stream-dashboard"
          state_file="$state_dir/swaync-dnd"

          case "''${1:-}" in
            start)
              mkdir -p "$state_dir"
              if [[ ! -e "$state_file" ]]; then
                dnd_state="$(swaync-client --get-dnd --skip-wait)"
                case "$dnd_state" in
                  true | false) printf '%s\n' "$dnd_state" >"$state_file" ;;
                  *)
                    echo "Unable to read swaync DND state" >&2
                    exit 1
                    ;;
                esac
              fi
              swaync-client --dnd-on --skip-wait >/dev/null
              ;;
            stop)
              if [[ -e "$state_file" ]]; then
                dnd_state="$(<"$state_file")"
                case "$dnd_state" in
                  true) swaync-client --dnd-on --skip-wait >/dev/null ;;
                  false) swaync-client --dnd-off --skip-wait >/dev/null ;;
                  *) echo "Ignoring invalid saved swaync DND state" >&2 ;;
                esac
                rm -f "$state_file"
              fi
              rmdir "$state_dir" 2>/dev/null || true
              ;;
            *)
              echo "Usage: stream-dashboard-dnd {start|stop}" >&2
              exit 2
              ;;
          esac
        '';
      };

      dashboard = pkgs.writeShellApplication {
        name = "stream-dashboard";
        runtimeInputs = with pkgs; [
          chatterino2
          coreutils
          jq
          systemd
          util-linux
        ];
        text = ''
          target=${lib.escapeShellArg dashboardTarget}
          hyprctl=${lib.escapeShellArg hyprctl}
          obs=${lib.escapeShellArg (lib.getExe config.programs.obs-studio.finalPackage)}
          chatterino=${lib.escapeShellArg (lib.getExe pkgs.chatterino2)}
          firefox=${lib.escapeShellArg (lib.getExe config.programs.firefox.package)}
          manager_url=${lib.escapeShellArg managerUrl}

          runtime_dir="''${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set}"
          exec 9>"$runtime_dir/stream-dashboard.lock"
          flock 9

          find_window() {
            "$hyprctl" -j clients | jq -er --arg kind "$1" '
              first(
                .[]
                | select(
                    if $kind == "obs" then
                      ((.class // "") | ascii_downcase) as $class
                      | $class == "com.obsproject.studio" or $class == "obs"
                    elif $kind == "chat" then
                      ((.class // "") | ascii_downcase) == "chatterino"
                    elif $kind == "manager" then
                      ((.tags // []) | index("stream-dashboard") != null)
                      or ((.title // "") | test("stream manager.*twitch|twitch.*stream manager"; "i"))
                    else
                      false
                    end
                  )
                | .address
              )
            ' 2>/dev/null
          }

          wait_for_window() {
            local kind="$1"
            local address
            for _ in $(seq 1 200); do
              if address="$(find_window "$kind")"; then
                printf '%s\n' "$address"
                return 0
              fi
              sleep 0.1
            done
            return 1
          }

          focus_window() {
            "$hyprctl" --quiet dispatch focuswindow "address:$1"
          }

          show_obs() {
            local address
            if ! address="$(find_window obs)"; then
              "$obs" --profile Programming --collection Programming >/dev/null 2>&1 &
              address="$(wait_for_window obs)" || {
                echo "OBS did not open" >&2
                return 1
              }
            fi
            focus_window "$address"
          }

          show_chat() {
            local address
            if ! address="$(find_window chat)"; then
              "$chatterino" >/dev/null 2>&1 &
              address="$(wait_for_window chat)" || {
                echo "Chatterino did not open" >&2
                return 1
              }
            fi
            "$hyprctl" --quiet dispatch movetoworkspacesilent "11,address:$address"
            if "$hyprctl" -j monitors | jq -e 'any(.[]; .name == "DP-3")' >/dev/null; then
              "$hyprctl" --quiet dispatch moveworkspacetomonitor "11 DP-3"
            fi
            focus_window "$address"
          }

          show_manager() {
            local address
            local previous_firefox
            if ! address="$(find_window manager)"; then
              previous_firefox="$("$hyprctl" -j clients | jq -c '[.[] | select(((.class // "") | ascii_downcase) == "firefox") | .address]')"
              "$firefox" --new-instance -P stream-dashboard --new-window "$manager_url" >/dev/null 2>&1 &

              for _ in $(seq 1 200); do
                if address="$(
                  "$hyprctl" -j clients \
                    | jq -er --argjson previous "$previous_firefox" '
                        first(
                          .[]
                          | select(((.class // "") | ascii_downcase) == "firefox")
                          | select(.address as $address | $previous | index($address) | not)
                          | .address
                        )
                      ' 2>/dev/null
                )"; then
                  "$hyprctl" --quiet dispatch tagwindow "+stream-dashboard,address:$address"
                  break
                fi
                sleep 0.1
              done

              if [[ -z "''${address:-}" ]]; then
                echo "Twitch Stream Manager did not open" >&2
                return 1
              fi
            fi
            focus_window "$address"
          }

          start_dashboard() {
            systemctl --user start "$target"
            if ! { show_obs && show_manager && show_chat && show_obs; }; then
              systemctl --user stop "$target"
              return 1
            fi
          }

          case "''${1:-start}" in
            start) start_dashboard ;;
            stop) systemctl --user stop "$target" ;;
            toggle)
              if systemctl --user --quiet is-active "$target"; then
                systemctl --user stop "$target"
              else
                start_dashboard
              fi
              ;;
            obs) show_obs ;;
            chat) show_chat ;;
            manager) show_manager ;;
            status) systemctl --user is-active "$target" ;;
            *)
              echo "Usage: stream-dashboard {start|stop|toggle|obs|chat|manager|status}" >&2
              exit 2
              ;;
          esac
        '';
      };

      execDashboard =
        command:
        lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${lib.getExe dashboard} ${command}"})";
      bind = key: command: {
        _args = [
          (lib.generators.mkLuaInline ''modifier .. " + ALT + ${key}"'')
          (execDashboard command)
        ];
      };
    in
    {
      programs.firefox.profiles.stream-dashboard = {
        id = 2;
        settings = {
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage" = managerUrl;
          "browser.startup.page" = 1;
          "browser.tabs.closeWindowWithLastTab" = false;
        };
      };

      stylix.targets.firefox.profileNames = lib.mkAfter [ "stream-dashboard" ];

      home.packages = [
        dashboard
        pkgs.showmethekey
      ];

      systemd.user = {
        targets.stream-dashboard.Unit = {
          Description = "Streaming dashboard session";
          Requires = [
            "stream-dashboard-dnd.service"
            "stream-dashboard-inhibit.service"
            "stream-dashboard-keys.service"
          ];
        };

        services = {
          stream-dashboard-dnd = {
            Unit = {
              Description = "Manage notification DND for the streaming dashboard";
              PartOf = [ dashboardTarget ];
              Before = [ dashboardTarget ];
              Wants = [ "swaync.service" ];
              After = [ "swaync.service" ];
            };
            Service = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${lib.getExe dashboardDnd} start";
              ExecStop = "${lib.getExe dashboardDnd} stop";
            };
          };

          stream-dashboard-inhibit = {
            Unit = {
              Description = "Inhibit idle while the streaming dashboard is active";
              PartOf = [ dashboardTarget ];
              Before = [ dashboardTarget ];
            };
            Service.ExecStart =
              "${lib.getExe' pkgs.systemd "systemd-inhibit"} --what=idle --who=stream-dashboard "
              + "--why=\"Streaming dashboard active\" --mode=block ${lib.getExe' pkgs.coreutils "sleep"} infinity";
          };

          stream-dashboard-keys = {
            Unit = {
              Description = "Show typed keys while the streaming dashboard is active";
              PartOf = [ dashboardTarget ];
              Before = [ dashboardTarget ];
              After = [ "graphical-session.target" ];
            };
            Service = {
              ExecStart = "${lib.getExe' pkgs.showmethekey "showmethekey-gtk"} --no-app-win --keys-win --no-clickable";
              Restart = "on-failure";
              RestartSec = 1;
            };
          };
        };
      };

      wayland.windowManager.hyprland.settings.window_rule = lib.mkAfter [
        {
          match.class = "^(one\\.alynx\\.showmethekey)$";
          float = true;
          pin = true;
          no_focus = true;
          monitor = "DP-4";
        }
      ];

      # SUPER+ALT: S starts, X stops, O focuses OBS, T focuses Stream Manager,
      # and H focuses chat.
      wayland.windowManager.hyprland.settings.bind = [
        (bind "S" "start")
        (bind "X" "stop")
        (bind "O" "obs")
        (bind "T" "manager")
        (bind "H" "chat")
      ];
    };
}
