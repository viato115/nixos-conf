{ pkgs, lib, hostname, ... }:

let
  menuTheme = pkgs.writeText "niri-power-menu.rasi" ''
    * {
      font: "Mononoki Nerd Font 14";
      background-color: transparent;
      text-color: #c0caf5;
    }

    window {
      width: 620px;
      background-color: #1a1b26;
      border: 1px;
      border-color: #414868;
      border-radius: 3px;
    }

    mainbox {
      padding: 20px;
      children: [ message, listview ];
    }

    message {
      padding: 0px 0px 16px 0px;
      text-color: #ff9e64;
    }

    listview {
      columns: 3;
      lines: 2;
      spacing: 10px;
      fixed-height: true;
    }

    element {
      padding: 18px 8px;
      background-color: #24283b;
      border-radius: 3px;
    }

    element selected {
      background-color: #ff9e64;
      text-color: #1a1b26;
    }

    element-text {
      background-color: transparent;
      text-color: inherit;
      horizontal-align: 0.5;
      vertical-align: 0.5;
    }
  '';

  powerMenu = pkgs.writeShellApplication {
    name = "niri-power-menu";

    runtimeInputs = [
      pkgs.rofi
      pkgs.hyprlock
      pkgs.systemd
    ];

    text = ''
      options=(
        "  Lock"
        "󰤄  Sleep"
      )

      ${lib.optionalString (hostname == "nixpad") ''
        options+=("󰒲  Hibernate")
      ''}

      options+=(
        "󰜉  Reboot"
        "󰐥  Power off"
      )

      choice=$(
        printf '%s\n' "''${options[@]}" |
          rofi -no-config -dmenu -no-custom \
            -theme "${menuTheme}" \
            -mesg "Power"
      ) || exit 0

      if [ "''${1:-}" = "--preview" ]; then
        printf 'Preview selection: %s\n' "$choice"
        exit 0
      fi

      if [ "$choice" = "  Lock" ]; then
        exec hyprlock
      fi

      confirmation=$(
        printf '%s\n' "Cancel" "Confirm" |
          rofi -no-config -dmenu -no-custom \
            -theme "${menuTheme}" \
            -mesg "Confirm: $choice?"
      ) || exit 0

      [ "$confirmation" = "Confirm" ] || exit 0

      case "$choice" in
        "󰤄  Sleep")      systemctl suspend ;;
        "󰒲  Hibernate")  systemctl hibernate ;;
        "󰜉  Reboot")     systemctl reboot ;;
        "󰐥  Power off")  systemctl poweroff ;;
      esac
    '';
  };
in
{
  home.packages = [ powerMenu ];
}
