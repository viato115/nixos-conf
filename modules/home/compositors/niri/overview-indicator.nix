{ lib, pkgs, hostname, ... }:
let
  overviewConfig = pkgs.writeText "niri-overview-waybar.json" (builtins.toJSON {
    layer = "top";
    position = "top";
    width = 250;
    height = 36;
    margin-top = 226;
    exclusive = false;
    start_hidden = false;
    on-sigusr1 = "noop";
    modules-center = [ "clock" ] ++ lib.optionals (hostname == "nixpad") [ "battery" ];
    clock = {
      format = "󰥔  {:%H:%M}";
      tooltip-format = "{:%A, %d %B %Y}";
    };
    battery = {
      format = "{icon}  {capacity}%";
      format-charging = "󰂄  {capacity}%";
      format-plugged = "󰂄  {capacity}%";
      format-icons = [ "󰁺" "󰁻" "󰁽" "󰁿" "󰂁" "󰁹" ];
      tooltip = true;
      states = { warning = 20; critical = 10; };
    };
  });

  overviewStyle = pkgs.writeText "niri-overview-waybar.css" ''
    * {
      font-family: "Mononoki Nerd Font", monospace;
      font-size: 22px;
      font-weight: bold;
      border: none;
      min-height: 0;
    }
    window#waybar {
      background: transparent;
      color: #c0caf5;
      box-shadow: none;
    }
    #clock, #battery {
      background: transparent;
      padding: 0 10px;
      text-shadow: 0 1px 4px rgba(0, 0, 0, 1);
    }
    #clock { color: #ff9e64; }
    #battery { color: #ff9e64; }
    #battery.warning { color: #e0af68; }
    #battery.critical { color: #f7768e; }
    tooltip {
      background-color: #1a1b26;
      color: #c0caf5;
      border: 1px solid #414868;
      border-radius: 3px;
    }
  '';
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "niri-overview-indicator";
      runtimeInputs = [ pkgs.coreutils pkgs.jq pkgs.niri pkgs.waybar ];
      text = ''
        bar_pid=""
        bar_config=""
        bar_output=""
        overview_open=false

        stop_bar() {
          if [ -n "$bar_pid" ]; then
            kill "$bar_pid" 2>/dev/null || true
            wait "$bar_pid" 2>/dev/null || true
          fi
          if [ -n "$bar_config" ]; then
            rm -f -- "$bar_config"
          fi
          bar_pid=""
          bar_config=""
          bar_output=""
        }
        trap stop_bar EXIT
        trap 'exit 0' INT TERM

        sync_bar() {
          output="$(niri msg --json focused-output | jq -er '.name | select(type == "string" and length > 0)')" || return 0
          if [ "$output" = "$bar_output" ] && [ -n "$bar_pid" ] && kill -0 "$bar_pid" 2>/dev/null; then
            return 0
          fi

          stop_bar
          bar_config="$(mktemp "$XDG_RUNTIME_DIR/niri-overview-waybar.XXXXXXXX")"
          jq --arg output "$output" '.output = $output' ${overviewConfig} > "$bar_config"
          waybar -c "$bar_config" -s ${overviewStyle} &
          bar_pid=$!
          bar_output="$output"
        }

        while IFS= read -r event; do
          case "$event" in
            open)
              overview_open=true
              sync_bar
              ;;
            close)
              overview_open=false
              stop_bar
              ;;
            focus)
              if [ "$overview_open" = true ]; then
                sync_bar
              fi
              ;;
          esac
        done < <(
          niri msg --json event-stream | jq --unbuffered -r '
            if .OverviewOpenedOrClosed != null then
              if .OverviewOpenedOrClosed.is_open then "open" else "close" end
            elif .WorkspaceActivated.focused == true then "focus"
            elif .WorkspacesChanged != null then "focus"
            else empty end
          '
        )
      '';
    })
  ];
}
